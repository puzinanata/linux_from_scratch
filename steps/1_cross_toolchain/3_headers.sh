#!/bin/bash

# for debug on remote comp directly
#BUILD_DIR=/mnt/new_root_dir/build

PACKAGE_URL='https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.13.4.tar.xz'
PACKAGE_NAME='linux-6.13.4.tar.xz'
PACKAGE_MD5='13b9e6c29105a34db4647190a43d1810'
PACKAGE_DIR_NAME='linux-6.13.4'

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

# Make sure there are no stale files embedded in the package
make mrproper

#Build
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr


popd
popd
popd
