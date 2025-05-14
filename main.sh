#!/bin/bash

set -e
set -x

# Clean previous result
rm -rfv /tools
rm -rfv /mnt/new_root_dir

# Init variables
PACKAGE_CACHE=/var/lib/lfs
LFS=/mnt/new_root_dir
BUILD_DIR=/mnt/new_root_dir/build
LFS_TGT=$(uname -m)-lfs-linux-gnu

# Create directories
# 4.2. Creating a Limited Directory Layout in the LFS Filesystem
mkdir -v -p "${PACKAGE_CACHE}"
mkdir -v -p "${LFS}"
mkdir -v -p "${BUILD_DIR}"

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

# Install base requirements
apt install -y bison

source steps/1_cross_toolchain/1_binutils.sh
source steps/1_cross_toolchain/2_gcc.sh
source steps/1_cross_toolchain/3_headers.sh
source steps/1_cross_toolchain/4_glibc.sh
