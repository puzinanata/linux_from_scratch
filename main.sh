#!/bin/bash

set -e
set -x

# Clean previous result
rm -rfv /tools
rm -rfv /mnt/new_root_dir/*

# Init variables
PACKAGE_CACHE=/var/lib/lfs
LFS=/mnt/new_root_dir
BUILD_DIR=/mnt/new_root_dir/build
LFS_TGT=$(uname -m)-lfs-linux-gnu
JOBS=$(nproc)


# Create directories
# Creating a Limited Directory Layout in the LFS Filesystem
mkdir -v -p "${PACKAGE_CACHE}"
mkdir -v -p "${LFS}"
mkdir -v -p "${BUILD_DIR}"

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -svf usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

# Install basic requirements
apt update
apt install -y \
   bison \
   bzip2 \
   gcc \
   make \
   texinfo \
   g++ \
   gawk \
   patch \
   xz-utils \
   curl \
   python3

# step 1
source steps/1_cross_toolchain/1_binutils.sh
source steps/1_cross_toolchain/2_gcc.sh
source steps/1_cross_toolchain/3_headers.sh
source steps/1_cross_toolchain/4_glibc.sh
source steps/1_cross_toolchain/5_libstdc.sh

# step 2
source steps/2_cross_tmp_tools/1_m4.sh
source steps/2_cross_tmp_tools/2_ncurses.sh
source steps/2_cross_tmp_tools/3_bash.sh
source steps/2_cross_tmp_tools/4_coreutils.sh
source steps/2_cross_tmp_tools/5_diffutils.sh
source steps/2_cross_tmp_tools/6_file.sh
source steps/2_cross_tmp_tools/7_findutils.sh
source steps/2_cross_tmp_tools/8_gawk.sh
source steps/2_cross_tmp_tools/9_grep.sh
source steps/2_cross_tmp_tools/10_gzip.sh
source steps/2_cross_tmp_tools/11_make.sh
source steps/2_cross_tmp_tools/12_patch.sh
source steps/2_cross_tmp_tools/13_sed.sh
source steps/2_cross_tmp_tools/14_tar.sh
source steps/2_cross_tmp_tools/15_xz.sh
PATH=$LFS/tools/bin:$PATH
source steps/2_cross_tmp_tools/16_binutils_pass2.sh
source steps/2_cross_tmp_tools/17_gcc_pass2.sh

#step 3. chroot
source steps/3_chroot/0_prep_chroot.sh
source steps/3_chroot/enter_chroot.sh

echo "Installation LFS Finished"

set -e
set -x
#Creation disk to save LFS image
apt update
apt install -y qemu-utils
qemu-img create /var/lib/lfs.img 9G

#For debug
echo $PATH
#Create one partiotion '/'
/usr/sbin/fdisk /var/lib/lfs.img << EOF
n
p
1


a
w
EOF

DISK=$(flock --exclusive /tmp/losetup_get_new_dev.lock losetup -f --show "/var/lib/lfs.img")

#partitition
partprobe "$DISK"

#Formating
mkfs.ext4 -F "$DISK"p1

rm -rf /mnt/finish_root_dir
mkdir -p  /mnt/finish_root_dir

mount "$DISK"p1 /mnt/finish_root_dir

time mv /mnt/new_root_dir/* /mnt/finish_root_dir

#Chroot prerequisites
mount -v --bind /dev /mnt/finish_root_dir/dev
mount -vt proc proc /mnt/finish_root_dir/proc
mount -vt sysfs sysfs /mnt/finish_root_dir/sys
mount -vt tmpfs tmpfs /mnt/finish_root_dir/run

#set up password in system
chroot /mnt/finish_root_dir/ /bin/bash -c 'echo password | passwd -s'

#GRUB installation
chroot /mnt/finish_root_dir /bin/bash -c "/sbin/grub-install -v ${DISK} --modules='biosdisk part_msdos normal' --target=i386-pc"
chroot /mnt/finish_root_dir/ /bin/bash -c 'grub-mkconfig > /boot/grub/grub.cfg'

umount -v /mnt/finish_root_dir/run
umount -v /mnt/finish_root_dir/sys
umount -v /mnt/finish_root_dir/proc
umount -v /mnt/finish_root_dir/dev
umount -v /mnt/finish_root_dir/


losetup -d ${DISK}
echo "lfs image disk is ready"


