#!/bin/bash

PACKAGE_NAME='zlib-1.3.1.tar.gz'
PACKAGE_MD5='9855b6d802d7fe5b7bd5b196a2271655'
PACKAGE_DIR_NAME='zlib-1.3.1'

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

./configure --prefix=/usr

make -j$JOBS

make check

make install

rm -fv /usr/lib/libz.a

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}