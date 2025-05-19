#!/bin/bash

## for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu

PACKAGE_URL='https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz'
PACKAGE_NAME='ncurses-6.5.tar.gz'
PACKAGE_MD5='ac2d2629296f04c8537ca706b6977687'
PACKAGE_DIR_NAME='ncurses-6.5'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

# build the “tic” program on the build host
mkdir build
pushd build
  ../configure AWK=gawk
  make -C include
  make -C progs tic
popd


#Configure
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

#Build
make -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install

ln -sv libncursesw.so $LFS/usr/lib/libncurses.so

sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h


popd
popd
popd
