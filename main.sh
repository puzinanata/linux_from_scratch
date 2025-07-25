#!/bin/bash

set -e
set -x

# Clean previous result
umount -Rfv /mnt/new_root_dir || true
rm -rfv /tools
rm -rfv /mnt/new_root_dir/*

# Init variables
PACKAGE_CACHE=/var/lib/lfs
LFS=/mnt/new_root_dir
BUILD_DIR=/mnt/new_root_dir/build
LFS_TGT=$(uname -m)-lfs-linux-gnu
JOBS=$(nproc)


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
   python3 \
   qemu-utils \
   fdisk

#Creation disk to save LFS image
rm -fv /var/lib/lfs/lfs.img
qemu-img create /var/lib/lfs/lfs.img 15G

fdisk /var/lib/lfs/lfs.img << EOF
n
p
1


a
w
EOF

DISK=$(losetup --find --partscan --show /var/lib/lfs/lfs.img)

#Formating
mkfs.ext4 -F "$DISK"p1

mount "$DISK"p1 $LFS

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -svf usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

# Create directories
# Creating a Limited Directory Layout in the LFS Filesystem
mkdir -v -p "${PACKAGE_CACHE}"
mkdir -v -p "${LFS}"
mkdir -v -p "${BUILD_DIR}"

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

losetup -d ${DISK}
echo "lfs image disk is ready"