#!/bin/bash

# for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu
#JOBS=$(nproc)

PACKAGE_URL='https://github.com//tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.xz'
PACKAGE_NAME='xz-5.6.4.tar.xz'
PACKAGE_MD5='4b1cf07d45ec7eb90a01dd3c00311a3e'
PACKAGE_DIR_NAME='xz-5.6.4'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

#Configure
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.6.4

#Build
make -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}