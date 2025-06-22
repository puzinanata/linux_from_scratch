#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs

PACKAGE_NAME='flex-2.6.4.tar.gz'
PACKAGE_MD5='2882e3179748cc9f9c23ec593d6adc8d'
PACKAGE_DIR_NAME='flex-2.6.4'

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

./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static

make -j$JOBS

make install

ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}