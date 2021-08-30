#!/usr/bin/bash

set -e

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

pacman -S --noconfirm linux-headers base-devel grub os-prober networkmanager network-manager-applet dialog dosfstools neovim man-db man-pages alsa-utils pulseaudio git reflector xdg-utils xdg-user-dirs

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

useradd -m dan
echo dan:password | chpasswd

echo "dan ALL=(ALL) ALL" >> /etc/sudoers.d/dan

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

