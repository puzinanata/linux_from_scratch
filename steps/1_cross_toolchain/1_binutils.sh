#!/bin/bash

# for debug on remote comp directly
#BUILD_DIR=/mnt/new_root_dir/build

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
./configure --prefix=$LFS/tools  \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

#Build
make -j$JOBS

#Install build artefacts from previous step
make install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}

