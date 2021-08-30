target_drive=$1

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/$target_drive
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
