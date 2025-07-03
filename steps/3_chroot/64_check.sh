#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='check-0.15.2.tar.gz'
PACKAGE_MD5='50fcafcecde5a380415b12e9c574e0b2'
PACKAGE_DIR_NAME='check-0.15.2'

pushd "${PACKAGE_CACHE}"

if [ -f "${PACKAGE_NAME}" ]; then
  cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
fi

pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}" ]]; then
    tar -xzf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

./configure --prefix=/usr --disable-static

make -j$JOBS

make docdir=/usr/share/doc/check-0.15.2 install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
