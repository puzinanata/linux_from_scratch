#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs

PACKAGE_NAME='lz4-1.10.0.tar.gz'
PACKAGE_MD5='dead9f5f1966d9ae56e1e32761e4e675'
PACKAGE_DIR_NAME='lz4-1.10.0'

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

make BUILD_STATIC=no PREFIX=/usr

make BUILD_STATIC=no PREFIX=/usr install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}