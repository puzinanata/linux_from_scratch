#!/bin/bash

set -e
set -x

# Clean previous result
rm -rfv /tools
rm -rfv /mnt/new_root_dir

# Init variables
PACKAGE_CACHE=/var/lib/lfs
LINUX_PROJECT_ROOT_MOUNT_POINT=/mnt/new_root_dir
BUILD_DIR=/mnt/new_root_dir/build
LFS_TGT=$(uname -m)-lfs-linux-gnu

# Create directories
mkdir -v -p "${PACKAGE_CACHE}"
mkdir -v -p "${LINUX_PROJECT_ROOT_MOUNT_POINT}"
mkdir -v -p "${BUILD_DIR}"


source steps/1_pass/1_binutils.sh
source steps/1_pass/2_gcc.sh
