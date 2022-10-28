# QEMU
echo "[*]Installing QEMU"
sudo pacman -S qemu-full libvirt virt-manager bridge-utils virt-viewer samba

echo "[*]Setting up libvirtd"
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

echo "[*]Edit your libvirtd.conf file accordingly and add your user to libvirt group"
