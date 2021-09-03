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

pacman -S --noconfirm acpi acpi_call acpid alsa-utils avahi base-devel bluez bluez-utils dialog dosfstools efibootmgr firewalld grub intel-ucode linux-headers man-db man-pages networkmanager nss-mdns pipewire pipewire-alsa pipewire-pulse pipewire-jack os-prober tlc wpa_supplicant xf86-video-intel

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable acpid
systemctl enable avahi-daemon
systemctl enable bluetooth
systemctl enable firewalld
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable tlp

useradd -m dan
echo dan:password | chpasswd

echo "dan ALL=(ALL) ALL" >> /etc/sudoers.d/dan

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

