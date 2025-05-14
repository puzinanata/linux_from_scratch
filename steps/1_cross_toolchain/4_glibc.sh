#!/bin/bash

# for debug on remote comp directly
#BUILD_DIR=/mnt/new_root_dir/build
#PACKAGE_CACHE=/var/lib/lfs
#LFS=/mnt/new_root_dir
#LFS_TGT=$(uname -m)-lfs-linux-gnu

PACKAGE_URL='https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz'
PACKAGE_NAME='glibc-2.41.tar.xz'
PACKAGE_MD5='19862601af60f73ac69e067d3e9267d4'
PACKAGE_DIR_NAME='glibc-2.41'

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

#case $(uname -m) in
#    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
#    ;;
#    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
#            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
#    ;;
#esac

mkdir -v build
pushd build

LFS=/mnt/new_root_dir
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=5.4                \
      --with-headers=$LFS/usr/include    \
      --disable-nscd                     \
      --without-selinux                  \
      libc_cv_slibdir=/usr/lib

make

make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

popd
popd
popd
popd


## Test: ensure that the basic functions (compiling and linking) of the new toolchain are working as expected.
#echo 'int main(){}' | x86_64-lfs-linux-gnu-gcc -xc -
#readelf -l a.out | grep ld-linux
## expected output: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
#rm -v a.out