#!/bin/bash

PACKAGE_NAME='coreutils-9.6.tar.xz'
PACKAGE_MD5='0ed6cc983fe02973bc98803155cc1733'
PACKAGE_DIR_NAME='coreutils-9.6'

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

cp -v  "${PACKAGE_CACHE}"/coreutils-9.6-i18n-1.patch "${BUILD_DIR}/"
patch -Np1 -i ../coreutils-9.6-i18n-1.patch

autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make -j$JOBS

make install

mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}