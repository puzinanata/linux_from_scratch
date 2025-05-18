#!/bin/bash

# for debug on remote comp directly
#BUILD_DIR=/mnt/new_root_dir/build

PACKAGE_URL='https://ftp.gnu.org/gnu/gcc/gcc-12.4.0/gcc-12.4.0.tar.xz'
PACKAGE_NAME='gcc-12.4.0.tar.xz'
PACKAGE_MD5='fd7779aee878db67456575922281fa71'
PACKAGE_DIR_NAME='gcc-12.4.0'

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
#full path of PACKAGE_DIR_NAME
PACKAGE_DIR_NAME=$(pwd)
pushd "${PACKAGE_DIR_NAME}"

# Package 1 inside of gcc
PACKAGE_URL='https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz'
PACKAGE_NAME='mpfr-4.2.1.tar.xz'
PACKAGE_MD5='523c50c6318dde6f9dc523bc0244690a'

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
    mv -v mpfr-4.2.1 mpfr
    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

# Package 2 inside of gcc
PACKAGE_URL='https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz'
PACKAGE_NAME='gmp-6.3.0.tar.xz'
PACKAGE_MD5='956dc04e864001a9c22429f761f2c283'

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
    mv -v gmp-6.3.0 gmp
    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

# Package 3 inside of gcc
PACKAGE_URL='https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz'
PACKAGE_NAME='mpc-1.3.1.tar.gz'
PACKAGE_MD5='5c9bc658c9fd0f940e8e3e0f09530c62'

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
    mv -v mpc-1.3.1 mpc
    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
pushd    build

../configure                   \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.41 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

#Build
make -j7

# Install
make install

popd
popd
popd
popd
popd

