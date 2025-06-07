#!/bin/bash

PACKAGE_NAME='man-pages-6.12.tar.xz'
PACKAGE_MD5='44de430a598605eaba3e36dd43f24298'
PACKAGE_DIR_NAME='man-pages-6.12'

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

rm -v man3/crypt*

make -R GIT=false prefix=/usr install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}