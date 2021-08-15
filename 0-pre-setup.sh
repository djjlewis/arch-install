set -e

pacman -Syyy
reflector -c "United Kingdom" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy
loadkeys uk
timedatectl set-ntp true
