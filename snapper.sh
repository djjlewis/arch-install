sudo pacman -S --noconfirm snapper
sudo umount /.snapshots
sudo rm -rf /.snapshots

sudo snapper -c root create-config /

yay -S snap-pac-grub snapper-gui
# sudo chmod a+rx /.snapshots
# echo "Edit users in /etc/snapper/configs/root"
