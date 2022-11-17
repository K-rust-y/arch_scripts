# Installing X11
sudo pacman -S xorg-server xorg-apps xorg-xinit xterm

# Installing i3
sudo pacman -S i3-wm rofi i3status terminator i3lock

xinit i3

# Setting up zsh
sudo pacman -S zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"


# Copying i3 config
echo "[*]Copying i3config"
if [ ! -f "/home/krusty/repo/arch_scripts/i3config" ]
	then 
		echo "[*]No updating cause i3config not found"
	else
		mkdir "/home/krusty/.config"
		mkdir "/home/krusty/.config/i3"
		cp "/home/krusty/repo/arch_scripts/i3config" "/home/krusty/.config/i3/config"
fi

# Copying terminator config
echo "[*]Copying terminator config"
if [ ! -f "/home/krusty/repo/arch_scripts/terminator.config" ]
	then 
		echo "[*]No updating cause terminator.config not found"
	else
		mkdir "/home/krusty/.config/terminator"
		cp "/home/krusty/repo/arch_scripts/terminator.config" "/home/krusty/.config/terminator/config"
fi

# Configuring i3 to start with x11
touch /home/krusty/.xinitrc
echo "exec i3" >> /home/krusty/.xinitrc

# Start display manager
startx
