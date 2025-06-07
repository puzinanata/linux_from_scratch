#!/bin/bash

PACKAGE_NAME='iana-etc-20250123.tar.gz'
PACKAGE_MD5='f8a0ebdc19a5004cf42d8bdcf614fa5d'
PACKAGE_DIR_NAME='iana-etc-20250123'

pushd "${PACKAGE_CACHE}"

if [ -f "${PACKAGE_NAME}" ]; then
  cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
fi

pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}" ]]; then
    tar -xzf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

cp services protocols /etc

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}