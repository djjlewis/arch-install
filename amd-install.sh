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

pacman -S --noconfirm \
	acpi acpi_call acpid alsa-utils avahi \ 
	base-devel \
	dialog \
	dosfstools \
	efibootmgr \
	firewalld \
	grub \
	linux-headers \
	man-db man-pages \
	networkmanager \
	nss-mdns \
	pipewire pipewire-alsa pipewire-pulse pipewire-jack \
	openssh os-prober \
	wpa_supplicant

# common x11
pacman -S --noconfirm mesa xclip xdg-utils xdg-user-dirs xf86-video-amdgpu xorg-apps xorg-server xorg-xinit xterm 

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable acpid
systemctl enable avahi-daemon
systemctl enable firewalld
systemctl enable NetworkManager
systemctl enable sshd

useradd -m dan
echo dan:password | chpasswd

echo "dan ALL=(ALL) ALL" >> /etc/sudoers.d/dan

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

