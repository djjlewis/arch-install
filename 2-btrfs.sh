target_drive=$1

mkfs.btrfs /dev/${target_drive}3

mount /dev/${target_drive}3 /mnt

btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var_cache
btrfs su cr /mnt/@var_log
btrfs su cr /mnt/@snapshots

umount /mnt

mount -o noatime,compress=zstd,space_cache,subvol=@ /dev/{target_drive}3 /mnt

mkdir -p /mnt/{boot,home,var/cache,var/log,.snapshots}

mount -o noatime,compress=zstd,space_cache,subvol=@home /dev/${target_drive}3 /mnt/home
mount -o noatime,compress=zstd,space_cache,subvol=@var_cache /dev/${target_drive}3 /mnt/var/cache
mount -o noatime,compress=zstd,space_cache,subvol=@var_log /dev/${target_drive}3 /mnt/var/log
mount -o noatime,compress=zstd,space_cache,subvol=@snapshots /dev/${target_drive}3 /mnt/.snapshots

mount /dev/${target_drive}1 /mnt/boot
