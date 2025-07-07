#!/bin/bash
set -e

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='systemd-257.3.tar.gz'
PACKAGE_MD5='8e4fc90c7aead651fa5c50bd1b34abc2'
PACKAGE_DIR_NAME='systemd-257.3'

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

sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in

sed -i '/systemd-sysctl/s/^/#/' rules.d/99-systemd.rules.in

sed -e '/NETWORK_DIRS/s/systemd/udev/' \
    -i src/libsystemd/sd-network/network-util.h

rm -rf build
mkdir -p build
pushd    build

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D mode=release           \
      -D dev-kvm-mode=0660      \
      -D link-udev-shared=false \
      -D logind=false           \
      -D vconsole=false

export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
                      awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')

ninja udevadm systemd-hwdb                                           \
      $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
      $(realpath libudev.so --relative-to .)                         \
      $udev_helpers

install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
install -vm755 -d /usr/{lib,share}/pkgconfig
install -vm755 udevadm                             /usr/bin/
install -vm755 systemd-hwdb                        /usr/bin/udev-hwdb
ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
install -vm644 ../src/libudev/libudev.h            /usr/include/
install -vm644 src/libudev/*.pc                    /usr/lib/pkgconfig/
install -vm644 src/udev/*.pc                       /usr/share/pkgconfig/
install -vm644 ../src/udev/udev.conf               /etc/udev/
install -vm644 rules.d/* ../rules.d/README         /usr/lib/udev/rules.d/
install -vm644 $(find ../rules.d/*.rules \
                      -not -name '*power-switch*') /usr/lib/udev/rules.d/
install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} /usr/lib/udev/hwdb.d/
install -vm755 $udev_helpers                       /usr/lib/udev
install -vm644 ../network/99-default.link          /usr/lib/udev/network

popd
popd

# Installation package udev-lfs
PACKAGE_NAME='udev-lfs-20230818.tar.xz'
PACKAGE_MD5='acd4360d8a5c3ef320b9db88d275dae6'
PACKAGE_DIR_NAME='udev-lfs-20230818'

pushd "${PACKAGE_CACHE}"

if [ -f "${PACKAGE_NAME}" ]; then
  cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"
fi

pushd "${BUILD_DIR}"

MD5_ACTUAL=$(md5sum "${PACKAGE_NAME}"| awk '{ print $1 }')

if [[ "${MD5_ACTUAL}" == "${PACKAGE_MD5}" ]]; then
    tar -xJf "${PACKAGE_NAME}"
    echo "unpacked successfully."

    rm "${PACKAGE_NAME}"
    echo "Archive removed."

else
    echo "MD5 mismatch!"
fi


make -f udev-lfs-20230818/Makefile.lfs install


unset udev_helpers

udev-hwdb update

popd
popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
