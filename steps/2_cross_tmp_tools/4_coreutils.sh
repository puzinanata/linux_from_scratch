#!/bin/bash

# for debug on remote comp directly
PACKAGE_CACHE=/var/lib/lfs
LFS=/mnt/new_root_dir
BUILD_DIR=/mnt/new_root_dir/build
LFS_TGT=$(uname -m)-lfs-linux-gnu
JOBS=$(nproc)

PACKAGE_URL='https://ftp.gnu.org/gnu/coreutils/coreutils-9.6.tar.xz'
PACKAGE_NAME='coreutils-9.6.tar.xz'
PACKAGE_MD5='0ed6cc983fe02973bc98803155cc1733'
PACKAGE_DIR_NAME='coreutils-9.6'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

#Configure
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

#Build
make -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS install

mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

popd
popd
popd
