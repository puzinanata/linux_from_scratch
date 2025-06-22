#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs

PACKAGE_NAME='bc-7.0.3.tar.xz'
PACKAGE_MD5='ad4db5a0eb4fdbb3f6813be4b6b3da74'
PACKAGE_DIR_NAME='bc-7.0.3'

pushd "${PACKAGE_CACHE}"

if [ -f "${PACKAGE_NAME}" ]; then
  cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
fi

pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}" ]]; then
    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

CC=gcc ./configure --prefix=/usr -G -O3 -r

make -j$JOBS

make install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}