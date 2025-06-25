#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='gettext-0.24.tar.xz'
PACKAGE_MD5='87aea3013802a3c60fa3feb5c7164069'
PACKAGE_DIR_NAME='gettext-0.24'

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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.24

make -j$JOBS

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
