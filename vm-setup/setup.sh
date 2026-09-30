#!/usr/bin/env bash
# Post-install setup for the Debian 13 (trixie) dev VM, after a manual netinst install
# (GNOME desktop, LUKS). Run as your normal user:  ./setup.sh
# The system part runs as root through sudo, or through `su` (root password) if you are
# not in the sudo group yet. Idempotent: safe to re-run.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_MIN_VERSION="0.11"                 # minimum required by LazyVim
NVIM_DIR="/opt/nvim-linux-x86_64"
NVIM_RELEASE_API="https://api.github.com/repos/neovim/neovim/releases/tags/stable"
SHARE_TAG="host"                        # virtiofs tag configured on the qemu side
APT_PACKAGES=(
  sudo i3 vim tree curl wget git make unzip gcc ripgrep fd-find fzf tmux xclip luarocks
  rustup openjdk-21-jdk qemu-guest-agent spice-vdagent
)
REPOS=(
  https://github.com/K-rust-y/arch_scripts.git
  https://github.com/IsMyPhonePwned/bugreport-extractor-library.git
)

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
die() { echo "error: $*" >&2; exit 1; }
nvim_version() { "$1" --version 2>/dev/null | sed -n '1s/^NVIM v//p'; }  # e.g. 0.12.5
version_ge() { dpkg --compare-versions "$1" ge "$2"; }

# ================================================================ root part ==

install_neovim() {
  local cand
  cand="$(LC_ALL=C apt-cache policy neovim | awk '/Candidate:/ {print $2}')"

  if [[ -n $cand && $cand != "(none)" ]] && version_ge "$cand" "$NVIM_MIN_VERSION"; then
    log "Installing Neovim $cand from apt"
    apt-get install -y neovim
    # Drop a previous tarball install so there is only one nvim
    if [[ $(readlink /usr/local/bin/nvim 2>/dev/null) == "$NVIM_DIR/bin/nvim" ]]; then
      rm -f /usr/local/bin/nvim
    fi
    rm -rf "$NVIM_DIR"
    return
  fi

  log "apt has Neovim ${cand:-none} (< $NVIM_MIN_VERSION): using the latest stable release in $NVIM_DIR"
  if dpkg -s neovim >/dev/null 2>&1; then
    apt-get remove -y neovim neovim-runtime
  fi

  local digest
  digest="$(curl -fsSL "$NVIM_RELEASE_API" | python3 -c '
import json, sys
for a in json.load(sys.stdin)["assets"]:
    if a["name"] == "nvim-linux-x86_64.tar.gz":
        print(a["digest"].removeprefix("sha256:"))')"
  [[ -n $digest ]] || die "could not read the Neovim release checksum"

  if [[ $(cat "$NVIM_DIR/.release-sha256" 2>/dev/null) != "$digest" ]]; then
    local tmp ver
    tmp="$(mktemp -d)"
    curl -fL -o "$tmp/nvim.tar.gz" \
      https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
    echo "$digest  $tmp/nvim.tar.gz" | sha256sum -c --quiet - || die "Neovim checksum mismatch"
    tar -C "$tmp" -xzf "$tmp/nvim.tar.gz"
    ver="$(nvim_version "$tmp/nvim-linux-x86_64/bin/nvim")"
    version_ge "$ver" "$NVIM_MIN_VERSION" || die "downloaded Neovim $ver is older than $NVIM_MIN_VERSION"
    rm -rf "$NVIM_DIR"
    mv "$tmp/nvim-linux-x86_64" "$NVIM_DIR"
    echo "$digest" > "$NVIM_DIR/.release-sha256"
    rm -rf "$tmp"
  fi
  ln -sfn "$NVIM_DIR/bin/nvim" /usr/local/bin/nvim
  echo "Neovim $(nvim_version /usr/local/bin/nvim) installed"
}

system_setup() {
  local user=$1 home
  home="$(getent passwd "$user" | cut -d: -f6)"
  [[ -n $home ]] || die "unknown user $user"

  log "Installing packages"
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y "${APT_PACKAGES[@]}"

  # Stock sudoers: members of the "sudo" group get full sudo (with password)
  log "Adding $user to the sudo group"
  usermod -aG sudo "$user"

  install_neovim

  log "Configuring virtiofs share ($SHARE_TAG -> $home/host_shared)"
  install -d -o "$user" -g "$user" "$home/host_shared"
  if ! grep -qE "^${SHARE_TAG}[[:space:]]+${home}/host_shared[[:space:]]" /etc/fstab; then
    # nofail: boot still succeeds if the VM is started without the share
    echo "${SHARE_TAG} ${home}/host_shared virtiofs defaults,nofail 0 0" >> /etc/fstab
    systemctl daemon-reload
  fi
  mountpoint -q "$home/host_shared" || mount "$home/host_shared" 2>/dev/null \
    || echo "   (share not mounted: is virtiofs configured on the host?)"
}

# ================================================================ user part ==

user_setup() {
  # Debian ships fd as "fdfind" (name clash with another package); expose it as "fd"
  mkdir -p "$HOME/.local/bin"
  ln -sfn /usr/bin/fdfind "$HOME/.local/bin/fd"

  log "Installing dotfiles (i3, nvim, monitors)"
  install -Dm644 "$HERE/dotfiles/i3/config"    "$HOME/.config/i3/config"
  install -Dm644 "$HERE/dotfiles/monitors.xml" "$HOME/.config/monitors.xml"
  mkdir -p "$HOME/.config/nvim"
  cp -rT "$HERE/dotfiles/nvim" "$HOME/.config/nvim"

  log "Installing JetBrainsMono Nerd Font"
  if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    local tmp
    tmp="$(mktemp -d)"
    curl -fL -o "$tmp/font.zip" \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    mkdir -p "$HOME/.local/share/fonts"
    unzip -oq "$tmp/font.zip" -d "$HOME/.local/share/fonts"
    fc-cache -f >/dev/null
    rm -rf "$tmp"
  fi

  log "Loading GNOME Terminal profile"
  if [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    dconf load /org/gnome/terminal/ < "$HERE/dotfiles/gnome-terminal.dconf"
  else  # e.g. from a TTY: start a throwaway session bus just for dconf
    dbus-run-session -- dconf load /org/gnome/terminal/ < "$HERE/dotfiles/gnome-terminal.dconf"
  fi

  log "Setting up Rust toolchain"
  rustup default stable
  rustup component add rust-src rust-analyzer

  log "Cloning repositories into ~/Repo"
  mkdir -p "$HOME/Repo"
  local url dir
  for url in "${REPOS[@]}"; do
    dir="$HOME/Repo/$(basename "$url" .git)"
    [[ -d "$dir/.git" ]] || git clone "$url" "$dir"
  done

  log "Installing Claude Code"
  command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash

  log "Bootstrapping LazyVim plugins (headless)"
  nvim --headless "+Lazy! restore" +qa || echo "   (plugin restore failed: open nvim to finish)"
}

# ===================================================================== main ==

if [[ ${1:-} == --system ]]; then
  [[ $EUID -eq 0 && -n ${2:-} ]] || die "--system must be run as root with a user name"
  # Plain `su` keeps the user PATH (no /usr/sbin: usermod, ...): set a full root PATH
  export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  system_setup "$2"
  exit
fi

[[ $EUID -ne 0 ]] || die "run as your normal user, not root"

log "System setup (as root)"
if id -nG | grep -qw sudo; then
  sudo bash "$HERE/setup.sh" --system "$USER"
else
  echo "You are not in the sudo group yet: enter the ROOT password."
  su - root -c "bash $(printf %q "$HERE/setup.sh") --system $(printf %q "$USER")"
fi

user_setup

log "Done"
id -nG | grep -qw sudo || echo "Log out and back in so the sudo group membership takes effect."
echo "To use i3, log out and pick the i3 session on the login screen."
