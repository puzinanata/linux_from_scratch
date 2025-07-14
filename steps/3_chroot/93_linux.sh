#!/bin/bash

set -e
set -x

JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build

PACKAGE_NAME='linux-6.13.4.tar.xz'
PACKAGE_MD5='13b9e6c29105a34db4647190a43d1810'
PACKAGE_DIR_NAME='linux-6.13.4'

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

#Go to unpacked dir with source
pushd "${PACKAGE_DIR_NAME}"

make mrproper
make defconfig

make -j"${JOBS}"
make modules_install

# Install kernel image and config
rm -f /boot/vmlinuz-6.13.4-lfs
cp -v arch/x86/boot/bzImage /boot/vmlinuz-6.13.4-lfs

cp -v System.map /boot/System.map-6.13.4
cp -v .config /boot/config-6.13.4

popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
