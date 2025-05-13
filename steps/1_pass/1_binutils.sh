#!/bin/bash

# for debug on remote comp directly
#BUILD_DIR=/mnt/new_root_dir/build

PACKAGE_URL='http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2'
PACKAGE_NAME='binutils-2.25.tar.bz2'
PACKAGE_MD5='d9f3303f802a5b6b0bb73a335ab89d66'
PACKAGE_DIR_NAME='binutils-2.25'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xjf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

#Configure
./configure                                           \
    --prefix=/tools                                   \
    --with-sysroot=${LINUX_PROJECT_ROOT_MOUNT_POINT}  \
    --with-lib-path=/tools/lib                        \
    --target=${LFS_TGT}                                \
    --disable-nls                                     \
    --disable-werror

#Build
make -j4

#Install build artefacts from previous step
make install

#Create a symlink to ensure the sanity of the toolchain
case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib/tools/lib64 ;;
esac

popd
popd
popd
