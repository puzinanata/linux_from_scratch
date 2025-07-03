#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='gawk-5.3.1.tar.xz'
PACKAGE_MD5='4e9292a06b43694500e0620851762eec'
PACKAGE_DIR_NAME='gawk-5.3.1'

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

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make -j$JOBS

rm -f /usr/bin/gawk-5.3.1
make install

ln -sfv gawk.1 /usr/share/man/man1/awk.1

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
