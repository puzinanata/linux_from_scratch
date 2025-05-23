#!/bin/bash

## for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu
#JOBS=$(nproc)

PACKAGE_URL='https://ftp.gnu.org/gnu/diffutils/diffutils-3.11.tar.xz'
PACKAGE_NAME='diffutils-3.11.tar.xz'
PACKAGE_MD5='75ab2bb7b5ac0e3e10cece85bd1780c2'
PACKAGE_DIR_NAME='diffutils-3.11'

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
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

#Build
make -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}