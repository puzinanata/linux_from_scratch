#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs

PACKAGE_NAME='zstd-1.5.7.tar.gz'
PACKAGE_MD5='780fc1896922b1bc52a4e90980cdda48'
PACKAGE_DIR_NAME='zstd-1.5.7'

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

make prefix=/usr

make prefix=/usr install

rm -v /usr/lib/libzstd.a

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}