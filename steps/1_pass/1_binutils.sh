#!/bin/bash


cd "${BUILD_DIR}"
curl -LO 'http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2'

md5_actual=$(md5sum binutils-2.25.tar.bz2 | awk '{ print $1 }')

if [[ "$md5_actual" == "d9f3303f802a5b6b0bb73a335ab89d66" ]]; then
    tar -xjf binutils-2.25.tar.bz2
    echo "unpacked successfully."

    rm binutils-2.25.tar.bz2
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
cd binutils-2.25
#Configure binutils
./configure                                           \
    --prefix=/tools                                   \
    --with-sysroot=${LINUX_PROJECT_ROOT_MOUNT_POINT}  \
    --with-lib-path=/tools/lib                        \
    --disable-nls                                     \
    --disable-werror
#Build
make
#Install build artefacts from previous step
make install