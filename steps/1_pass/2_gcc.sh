#!/bin/bash

# for debug on remote comp directly
#BUILD_DIR=/mnt/new_root_dir/build

PACKAGE_URL='http://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2'
PACKAGE_NAME='gcc-4.9.2.tar.bz2'
PACKAGE_MD5='4df8ee253b7f3863ad0b86359cd39c43'
PACKAGE_DIR_NAME='gcc-4.9.2'

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
#pushd full path of PACKAGE_DIR_NAME
PACKAGE_DIR_NAME=$(pwd)
pushd "${PACKAGE_DIR_NAME}"

# Package 1 inside of gcc
PACKAGE_URL='http://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.xz'
PACKAGE_NAME='mpfr-3.1.2.tar.xz'
PACKAGE_MD5='e3d203d188b8fe60bb6578dd3152e05c'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${PACKAGE_DIR_NAME}"

popd

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."
    mv -v mpfr-3.1.2 mpfr
    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

# Package 2 inside of gcc
PACKAGE_URL='http://ftp.gnu.org/gnu//gmp/gmp-6.0.0a.tar.xz'
PACKAGE_NAME='gmp-6.0.0a.tar.xz'
PACKAGE_MD5='1e6da4e434553d2811437aa42c7f7c76'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${PACKAGE_DIR_NAME}"

popd

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."
    mv -v gmp-6.0.0 gmp
    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

# Package 3 inside of gcc
PACKAGE_URL='https://ftp.gnu.org/gnu/mpc/mpc-1.0.2.tar.gz'
PACKAGE_NAME='mpc-1.0.2.tar.gz'
PACKAGE_MD5='68fadff3358fb3e7976c7a398a0af4c3'

pushd "${PACKAGE_CACHE}"

if [ ! -f "${PACKAGE_NAME}" ]; then
  curl -LO "${PACKAGE_URL}"
fi

cp -v "${PACKAGE_NAME}" "${PACKAGE_DIR_NAME}"

popd

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}"  ]]; then
    tar -xzf "${PACKAGE_NAME}"
    echo "unpacked successfully."
    mv -v mpc-1.0.2 mpc
    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1
"/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

./configure \
    --target=$LFS_TGT  \
    --prefix=/tools    \
    --with-sysroot="${LINUX_PROJECT_ROOT_MOUNT_POINT}" \
    --with-newlib       \
    --without-headers   \
    --with-local-prefix=/tools \
    --with-native-system-header-dir=/tools/include   \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-decimal-float \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libitm \
    --disable-libquadmath \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libvtv \
    --disable-libcilkrts \
    --disable-libstdc++-v3 \
    --enable-languages=c,c++

#Build
make -j4



popd
popd
popd

