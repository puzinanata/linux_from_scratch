#!/bin/bash

# for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu
#JOBS=$(nproc)

PACKAGE_URL='https://astron.com/pub/file/file-5.46.tar.gz'
PACKAGE_NAME='file-5.46.tar.gz'
PACKAGE_MD5='459da2d4b534801e2e2861611d823864'
PACKAGE_DIR_NAME='file-5.46'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

#Configure
./configure --prefix=/usr    \
            --host=$LFS_TGT  \
            --build=$(./config.guess)

#Build
make FILE_COMPILE=$(pwd)/build/src/file -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/libmagic.la

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}