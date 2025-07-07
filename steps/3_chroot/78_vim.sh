#!/bin/bash

set -x

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='vim-9.1.1166.tar.gz'
PACKAGE_MD5='718d43ce957ab7c81071793de176c2eb'
PACKAGE_DIR_NAME='vim-9.1.1166'

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

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make -j$JOBS

pushd src

make install || true

popd
popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
