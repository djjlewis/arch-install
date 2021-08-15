pacstrap /mnt base linux linux-firmware git vim btrfs-progs intel-ucode # amd-ucode, intel-ucode etc

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
