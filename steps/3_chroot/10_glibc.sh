#!/bin/bash

PACKAGE_NAME='glibc-2.41.tar.xz'
PACKAGE_MD5='19862601af60f73ac69e067d3e9267d4'
PACKAGE_DIR_NAME='glibc-2.41'

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

cp -v  "${PACKAGE_CACHE}"/glibc-2.41-fhs-1.patch "${BUILD_DIR}/"
patch -Np1 -i ../glibc-2.41-fhs-1.patch

rm -rf build
mkdir -v build
pushd build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=5.4                      \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib

make -j$JOBS

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make install

sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

localedef -i C -f UTF-8 C.UTF-8
localedef -i en_US -f UTF-8 en_US.UTF-8


#make localedata/install-locales

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

# Installation tzdata
PACKAGE_NAME='tzdata2025a.tar.gz'
PACKAGE_MD5='404229390c06b7440f5e48d12c1a3251'
PACKAGE_DIR_NAME='tzdata2025a'

pushd "${PACKAGE_CACHE}"

cp -v "${PACKAGE_NAME}" "${BUILD_DIR}/"

popd

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

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p Europe/Lisbon
unset ZONEINFO tz

tzselect

ln -sfv /usr/share/zoneinfo/Europe/Lisbon /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d


popd
popd
popd
popd
popd

rm -rf ${BUILD_DIR}/${PACKAGE_DIR_NAME}
rm -rf ${BUILD_DIR}/glibc-2.41