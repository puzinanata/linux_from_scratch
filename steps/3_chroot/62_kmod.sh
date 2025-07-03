#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='kmod-34.tar.xz'
PACKAGE_MD5='3e6c5c9ad9c7367ab9c3cc4f08dfde62'
PACKAGE_DIR_NAME='kmod-34'

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

rm -rf build
mkdir -p build
pushd       build

meson setup --prefix=/usr ..    \
            --sbindir=/usr/sbin \
            --buildtype=release \
            -D manpages=false

ninja

ninja install

popd
popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
