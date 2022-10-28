# Download packages
pacman -S dhcpcd networkmanager network-manager-applet

# Enable services
sudo systemctl enable dhcpcd
sudo systemctl start dhcpcd
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
