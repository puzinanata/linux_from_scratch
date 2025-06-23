#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='pkgconf-2.3.0.tar.xz'
PACKAGE_MD5='833363e77b5bed0131c7bc4cc6f7747b'
PACKAGE_DIR_NAME='pkgconf-2.3.0'

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

./configure --prefix=/usr              \
            --disable-static           \
            --docdir=/usr/share/doc/pkgconf-2.3.0

make -j$JOBS

make install

ln -svf pkgconf   /usr/bin/pkg-config
ln -svf pkgconf.1 /usr/share/man/man1/pkg-config.1

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}