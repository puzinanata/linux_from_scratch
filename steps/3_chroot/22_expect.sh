#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='expect5.45.4.tar.gz'
PACKAGE_MD5='00fce8de158422f5ccd2666512329bd2'
PACKAGE_DIR_NAME='expect5.45.4'

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

cp -v  "${PACKAGE_CACHE}"/expect-5.45.4-gcc14-1.patch "${BUILD_DIR}/"
patch -Np1 -i ../expect-5.45.4-gcc14-1.patch

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make -j$JOBS

make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
