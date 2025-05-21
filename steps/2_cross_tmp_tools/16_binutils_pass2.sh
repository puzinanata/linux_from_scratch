#!/bin/bash

# for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu
#JOBS=$(nproc)

PACKAGE_URL='https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz'
PACKAGE_NAME='binutils-2.44.tar.xz'
PACKAGE_MD5='49912ce774666a30806141f106124294'
PACKAGE_DIR_NAME='binutils-2.44'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}" ]]; then
    # Remove existing source dir if it exists
    if [ -d "${PACKAGE_DIR_NAME}" ]; then
        echo "Removing existing directory: ${PACKAGE_DIR_NAME}"
        rm -rf "${PACKAGE_DIR_NAME}"
    fi

    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build
pushd build

#Configure
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

#Build
make -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}


popd
popd
popd
popd
