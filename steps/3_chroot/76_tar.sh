#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='tar-1.35.tar.xz'
PACKAGE_MD5='a2d8042658cfd8ea939e6d911eaf4152'
PACKAGE_DIR_NAME='tar-1.35'

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

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make -j$JOBS

make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
