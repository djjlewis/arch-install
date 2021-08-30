set -e

pacman -Syyy
reflector -c "United Kingdom" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy
loadkeys uk
timedatectl set-ntp true

target_drive=sda

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/${target_drive}
  o
  n # new partition
  p # primary
  1 # partition number 1
    # default - start at beginning of disk
  +8G # 8 GB swap parttion
  t # type
  82 # Linux Swap
  n # new partition
  p # new partition
  2 # partion number 2


  t
  2
  83
  p # print the in-memory partition table
  w # write the partition table
EOF


mkswap /dev/${target_drive}1
swapon /dev/${target_drive}1

mkfs.btrfs /dev/${target_drive}2

mount /dev/${target_drive}2 /mnt

btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var_cache
btrfs su cr /mnt/@var_log
btrfs su cr /mnt/@snapshots

umount /mnt

mount -o noatime,compress=zstd,space_cache,subvol=@ /dev/${target_drive}2 /mnt

mkdir -p /mnt/{boot,home,var/cache,var/log,.snapshots}

mount -o noatime,compress=zstd,space_cache,subvol=@home /dev/${target_drive}2 /mnt/home
mount -o noatime,compress=zstd,space_cache,subvol=@var_cache /dev/${target_drive}2 /mnt/var/cache
mount -o noatime,compress=zstd,space_cache,subvol=@var_log /dev/${target_drive}2 /mnt/var/log
mount -o noatime,compress=zstd,space_cache,subvol=@snapshots /dev/${target_drive}2 /mnt/.snapshots

pacstrap /mnt base linux linux-firmware btrfs-progs intel-ucode git vim

genfstab -U /mnt >> /mnt/etc/fstab

#mkdir /mnt/root/arch-install
cp -r . /mnt/root/arch-install

arch-chroot /mnt
