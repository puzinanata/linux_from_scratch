#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='groff-1.23.0.tar.gz'
PACKAGE_MD5='5e4f40315a22bb8a158748e7d5094c7d'
PACKAGE_DIR_NAME='groff-1.23.0'

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

PAGE=A4 ./configure --prefix=/usr

make -j$JOBS

make install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
