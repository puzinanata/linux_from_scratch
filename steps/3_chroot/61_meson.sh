#!/bin/bash

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='meson-1.7.0.tar.gz'
PACKAGE_MD5='c20f3e5ebbb007352d22f4fd6ceb925c'
PACKAGE_DIR_NAME='meson-1.7.0'

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

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
