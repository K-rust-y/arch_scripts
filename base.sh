update_vimrc(){
sed -i "/^set rtp.*/a call vundle#begin()\nPlugin 'gmarik/Vundle.vim'\nPlugin 'vim-syntastic/syntastic'\nPlugin 'scrooloose/nerdtree.git'\nPlugin 'rust-lang/rust.vim'\nPlugin 'rust-lang-nursery/rustfmt'\nPlugin 'micha/vim-colors-solarized'\nPlugin 'godlygeek/tabular'\ncall vundle#end()" /home/krusty/.vimrc 
}

#Update
sudo pacman -Syu

#Sys utils
echo "[*]Get some sys utils"
sudo pacman -S  curl thunar spice-vdagent thunar-volman gfvs gvim remmina proxychains git coreutils feh flameshot iptables terminator bluez bluez-utils blueman unzip htop lshw pulseaudio alsa-utils pavucontrol xfce4-power-manager brightnessctl vlc libreoffice

# Net utils
echo "[*]Installing net utils"
sudo pacman -S  dnsutils nmap tcpdump wireshark-qt smbclient traceroute wget firefox iptables
sudo systemctl enable bluetooth

# Vim
echo "[*]Updating vim.rc"
if [ ! -f "/home/krusty/.vimrc" ]
	then 
		if [ ! -f "/home/krusty/repo/arch_config/.vimrc" ]
			then 
				echo "[*]No updating cause .vimrc not found anywhere"
			else
				cp "/home/krusty/repo/arch_config/.vimrc" "/home/krusty/.vimrc"
				update_vimrc
		fi
	else
		update_vimrc
fi

if [ ! -f "/home/krusty/.vim/bundle/Vundle.vim" ]
	then 
		git clone https://github.com/VundleVim/Vundle.vim.git /home/krusty/.vim/bundle/Vundle.vim
		echo "[*]Vundle dled, run :PluginInstall inside vim"
fi
