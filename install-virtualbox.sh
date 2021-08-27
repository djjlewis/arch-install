set -e

pacman -Syyy
reflector -c "United Kingdom" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy
loadkeys uk
timedatectl set-ntp true

target_drive=sda

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${target_drive}
  g # clear the in memory partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk
  +512M # 512 MB boot parttion
  t # type
  1 # EFI
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +8G # 8 GB swap parttion
  t # type
  2 # partion number 2
  19 # EFI
  n # new partition
  3 # partion number 3
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

mkfs.fat -F32 /dev/${target_drive}1

mkswap /dev/${target_drive}2

mkfs.btrfs /dev/${target_drive}3

mount /dev/${target_drive}3 /mnt

btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var_cache
btrfs su cr /mnt/@var_log
btrfs su cr /mnt/@snapshots

umount /mnt

mount -o noatime,compress=zstd,space_cache,subvol=@ /dev/${target_drive}3 /mnt

mkdir -p /mnt/{boot/efi,home,var/cache,var/log,.snapshots}

mount -o noatime,compress=zstd,space_cache,subvol=@home /dev/${target_drive}3 /mnt/home
mount -o noatime,compress=zstd,space_cache,subvol=@var_cache /dev/${target_drive}3 /mnt/var/cache
mount -o noatime,compress=zstd,space_cache,subvol=@var_log /dev/${target_drive}3 /mnt/var/log
mount -o noatime,compress=zstd,space_cache,subvol=@snapshots /dev/${target_drive}3 /mnt/.snapshots

mount /dev/${target_drive}1 /mnt/boot/efi
pacstrap /mnt base linux linux-firmware btrfs-progs intel-ucode git vim

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

pacman -S --noconfim linux-headers base-devel grub os-prober efibootmgr networkmanager network-manager-applet dosfstools base-devel

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

useradd -m dan
echo dan:password | chpasswd

echo "dan ALL=(ALL) ALL" >> /etc/sudoers.d/dan

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

