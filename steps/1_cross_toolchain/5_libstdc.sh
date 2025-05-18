#!/bin/bash

set -e

# for debug on remote comp directly
BUILD_DIR=/mnt/new_root_dir/build
LFS=/mnt/new_root_dir
LFS_TGT=$(uname -m)-lfs-linux-gnu

# installation this library runs inside existed package gcc-12.4.0
PACKAGE_DIR_NAME='gcc-12.4.0'
pushd "${BUILD_DIR}/${PACKAGE_DIR_NAME}"

rm -rf build/
mkdir -v build
pushd build

LFS=/mnt/new_root_dir
LFS_TGT=$(uname -m)-lfs-linux-gnu

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-libstdcxx-zoneinfo=no    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0

make -j4

make DESTDIR=$LFS install

rm -v -f $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

popd
popd