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
mkdir -v -p "${PACKAGE_CACHE}"
mkdir -v -p "${LFS}"
mkdir -v -p "${BUILD_DIR}"


source steps/1_cross_toolchain/1_binutils.sh
source steps/1_cross_toolchain/2_gcc.sh
