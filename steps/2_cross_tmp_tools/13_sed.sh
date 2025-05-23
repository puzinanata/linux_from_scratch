#!/bin/bash

# for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu
#JOBS=$(nproc)

PACKAGE_URL='https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz'
PACKAGE_NAME='sed-4.9.tar.xz'
PACKAGE_MD5='6aac9b2dbafcd5b7a67a8a9bcb8036c3'
PACKAGE_DIR_NAME='sed-4.9'

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