# Installing X11
sudo pacman -S xorg-server xorg-apps xorg-xinit

# Installing i3
sudo pacman -S i3-wm rofi i3status terminator i3lock

# Setting up zsh
sudo pacman -S zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Start display manager
startx

# Copying i3 config
echo "[*]Copying i3config"
if [ ! -f "/home/krusty/repo/arch_config/i3config" ]
	then 
		echo "[*]No updating cause i3config not found"
	else
		cp "/home/krusty/repo/arch_config/i3config" "/home/krusty/.config/i3/config"
fi

# Copying terminator config
echo "[*]Copying terminator config"
if [ ! -f "/home/krusty/repo/arch_config/terminator.config" ]
	then 
		echo "[*]No updating cause terminator.config not found"
	else
		cp "/home/krusty/repo/arch_config/terminator.config" "/home/krusty/.config/terminator/config"
fi
