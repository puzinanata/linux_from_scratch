#!/bin/bash

set -e
set -x

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='sqlite-autoconf-3490100.tar.gz'
PACKAGE_MD5='8d77d0779bcd9993eaef33431e2e0c30'
PACKAGE_DIR_NAME='sqlite-autoconf-3490100'

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

./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"         &&
make

make install

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
