#!/bin/bash

set -e
set -x

LFS=/mnt/new_root_dir
JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs

# Clean previous result
echo ">>> Unmounting previous LFS mounts if any..."

for mount_point in dev/shm dev/pts dev proc sys run; do
    if mountpoint -q "$LFS/$mount_point"; then
        umount -v "$LFS/$mount_point"
    fi
done

if mountpoint -q "$LFS/dev"; then
    umount -v "$LFS/dev"
fi

echo ">>> Mount cleanup complete."

# Prepare LFS for chroot environment
mkdir -pv $LFS/{dev,proc,sys,run}

# Mounting and Populating /dev
mount -v --bind /dev $LFS/dev

# Mounting Virtual Kernel File Systems
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

pushd $LFS
rm -rf ./lib64
ln -s ./usr/lib ./lib64
popd

# Copy chroot scripts inside $LFS/root/chroot_scripts
mkdir -p $LFS/root/chroot_scripts
cp -r /home/lfs/steps/3_chroot/* $LFS/root/chroot_scripts/
chmod +x $LFS/root/chroot_scripts/*.sh

# Copy downloaded packages to lfs env
mkdir -pv ${LFS}/var/lib/lfs

#Exclude lfs.img
ls -1 ${PACKAGE_CACHE}/ | grep -v 'lfs.img' | while read FILE; do
  cp -v ${PACKAGE_CACHE}/$FILE ${LFS}/var/lib/lfs/
done

# Entering chroot
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$JOBS"         \
    TESTSUITEFLAGS="-j$JOBS"    \
    /bin/bash --login -c "/root/chroot_scripts/main_chroot.sh"

#set up password in system
chroot $LFS /bin/bash -c 'echo password | passwd -s'

#GRUB installation
chroot $LFS /bin/bash -c "/sbin/grub-install -v ${DISK} --modules='biosdisk part_msdos normal' --target=i386-pc"
chroot $LFS /bin/bash -c 'grub-mkconfig > /boot/grub/grub.cfg'