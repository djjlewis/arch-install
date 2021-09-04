set -e

sudo pacman -S --noconfirm snapper
sudo umount /.snapshots
sudo rm -rf /.snapshots

sudo snapper -c root create-config /

sudo chmod a+rx /.snapshots
echo "Edit users in /etc/snapper/configs/root"

sudo systemctl enable grub-btrfs.path

#yay -S snap-pac-grub snapper-gui
