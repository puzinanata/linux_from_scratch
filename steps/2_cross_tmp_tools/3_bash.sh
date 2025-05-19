#!/bin/bash

## for debug on remote comp directly
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#BUILD_DIR=/mnt/new_root_dir/build
#LFS_TGT=$(uname -m)-lfs-linux-gnu

PACKAGE_URL='https://ftp.gnu.org/gnu/bash/bash-5.2.37.tar.gz'
PACKAGE_NAME='bash-5.2.37.tar.gz'
PACKAGE_MD5='9c28f21ff65de72ca329c1779684a972'
PACKAGE_DIR_NAME='bash-5.2.37'

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

#Configure
./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

#Build
make -j$JOBS

#Install build artefacts from previous step
make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh

popd
popd
popd
