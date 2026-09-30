# Debian 13 dev VM — post-install setup

1. Install Debian 13 from the netinst ISO yourself (GNOME desktop, encrypted LUKS partition).
2. Copy this folder into the VM (e.g. USB/ISO, `scp`, or `git clone`) and run, as your user:

       ./setup.sh

   If you set a root password during install, you are not in the `sudo` group yet: the script
   asks for the root password once (via `su`), adds you to `sudo`, and you log out/in afterwards.

What it does (safe to re-run):
- **Packages:** i3, vim, tree, curl, wget, git, make, unzip, gcc, ripgrep, fd-find (+ `fd` symlink), fzf, tmux, xclip, luarocks,
  rustup, openjdk-21-jdk, sudo, qemu-guest-agent, spice-vdagent
- **sudo:** adds you to the `sudo` group (stock sudoers, password required)
- **Neovim:** from apt if its version is ≥ 0.11 (LazyVim minimum), otherwise the latest stable
  release from GitHub, checksum-verified, in `/opt/nvim-linux-x86_64` + `/usr/local/bin/nvim`
- **tree-sitter CLI:** latest release (≥ 0.26.1, needed by nvim-treesitter; Debian's is too old),
  checksum-verified, in `/usr/local/bin/tree-sitter`
- **Share:** virtiofs tag `host` mounted on `~/host_shared` (fstab, `nofail`)
- **User config:** i3 config, LazyVim config + lockfile, monitors.xml, GNOME Terminal profile,
  JetBrainsMono Nerd Font (skipped if installed; reuses a local `JetBrainsMono.zip` found next to
  the script, in Downloads or in `~/host_shared` before downloading), Rust stable + rust-src + rust-analyzer

## Updating the dotfiles
Copy changed configs back into `dotfiles/`:

    cp ~/.config/i3/config dotfiles/i3/
    cp -r ~/.config/nvim/{init.lua,lazyvim.json,lazy-lock.json,lua} dotfiles/nvim/
    dconf dump /org/gnome/terminal/ > dotfiles/gnome-terminal.dconf
