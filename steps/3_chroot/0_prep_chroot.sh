#!/bin/bash

set -e
set -x

PACKAGE_CACHE=/var/lib/lfs
mkdir -pv "$PACKAGE_CACHE"

download_package() {
  local PACKAGE_URL="$1"
  local PACKAGE_NAME="$2"

  pushd "$PACKAGE_CACHE" > /dev/null

  if [ ! -f "$PACKAGE_NAME" ]; then
    echo ">>> Downloading $PACKAGE_NAME ..."
    curl -LO "$PACKAGE_URL"
  else
    echo ">>> $PACKAGE_NAME already exists. Skipping download."
  fi

  popd > /dev/null
}

# Package 1: gettext
download_package "https://ftp.gnu.org/gnu/gettext/gettext-0.24.tar.xz" "gettext-0.24.tar.xz"

# Package 2: bison
download_package "https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz" "bison-3.8.2.tar.xz"

# Package 3: perl
download_package "https://www.cpan.org/src/5.0/perl-5.40.1.tar.xz" "perl-5.40.1.tar.xz"

# Package 4: python
download_package "https://www.python.org/ftp/python/3.13.2/Python-3.13.2.tar.xz" "Python-3.13.2.tar.xz"

# Package 5: texinfo
download_package "https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz" "texinfo-7.2.tar.xz"

# Package 6: util-linux
download_package "https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.4.tar.xz" "util-linux-2.40.4.tar.xz"

# Download packages for installation basic requirements in lfs chroot
download_package "https://www.kernel.org/pub/linux/docs/man-pages/man-pages-6.12.tar.xz" "man-pages-6.12.tar.xz"
download_package "https://github.com/Mic92/iana-etc/releases/download/20250123/iana-etc-20250123.tar.gz" "iana-etc-20250123.tar.gz"
download_package "https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz" "glibc-2.41.tar.xz"
download_package "https://zlib.net/fossils/zlib-1.3.1.tar.gz" "zlib-1.3.1.tar.gz"
download_package "https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz" "bzip2-1.0.8.tar.gz"
download_package "https://github.com//tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.xz" "xz-5.6.4.tar.xz"
download_package "https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz" "lz4-1.10.0.tar.gz"
download_package "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz" "zstd-1.5.7.tar.gz"
download_package "https://astron.com/pub/file/file-5.46.tar.gz" "file-5.46.tar.gz"
download_package "https://ftp.gnu.org/gnu/readline/readline-8.2.13.tar.gz" "readline-8.2.13.tar.gz"
download_package "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz" "m4-1.4.19.tar.xz"
download_package "https://github.com/gavinhoward/bc/releases/download/7.0.3/bc-7.0.3.tar.xz" "bc-7.0.3.tar.xz"
download_package "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz" "flex-2.6.4.tar.gz"
download_package "https://downloads.sourceforge.net/tcl/tcl8.6.16-src.tar.gz" "tcl8.6.16-src.tar.gz"
download_package "https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz" "expect5.45.4.tar.gz"
download_package "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz" "dejagnu-1.6.3.tar.gz"
download_package "https://distfiles.ariadne.space/pkgconf/pkgconf-2.3.0.tar.xz" "pkgconf-2.3.0.tar.xz"
download_package "https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz" "binutils-2.44.tar.xz"
download_package "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz" "gmp-6.3.0.tar.xz"
download_package "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz" "mpfr-4.2.1.tar.xz"
download_package "https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz" "mpc-1.3.1.tar.gz"
download_package "https://download.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz" "attr-2.5.2.tar.gz"
download_package "https://download.savannah.gnu.org/releases/acl/acl-2.3.2.tar.xz" "acl-2.3.2.tar.xz"
download_package "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.73.tar.xz" "libcap-2.73.tar.xz"
download_package "https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz" "libxcrypt-4.4.38.tar.xz"
download_package "https://github.com/shadow-maint/shadow/releases/download/4.17.3/shadow-4.17.3.tar.xz" "shadow-4.17.3.tar.xz"
download_package "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz" "gcc-14.2.0.tar.xz"
download_package "https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz" "ncurses-6.5.tar.gz"
download_package "https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz" "sed-4.9.tar.xz"
download_package "https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.7.tar.xz" "psmisc-23.7.tar.xz"
download_package "https://ftp.gnu.org/gnu/gettext/gettext-0.24.tar.xz" "gettext-0.24.tar.xz"
download_package "https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz" "bison-3.8.2.tar.xz"
download_package "https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz" "grep-3.11.tar.xz"
download_package "https://ftp.gnu.org/gnu/bash/bash-5.2.37.tar.gz" "bash-5.2.37.tar.gz"
download_package "https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz" "libtool-2.5.4.tar.xz"
download_package "https://ftp.gnu.org/gnu/gdbm/gdbm-1.24.tar.gz" "gdbm-1.24.tar.gz"
download_package "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz" "gperf-3.1.tar.gz"
download_package "https://github.com/libexpat/libexpat/releases/download/R_2_6_4/expat-2.6.4.tar.xz" "expat-2.6.4.tar.xz"
download_package "https://ftp.gnu.org/gnu/inetutils/inetutils-2.6.tar.xz" "inetutils-2.6.tar.xz"
download_package "https://www.greenwoodsoftware.com/less/less-668.tar.gz" "less-668.tar.gz"
download_package "https://www.cpan.org/src/5.0/perl-5.40.1.tar.xz" "perl-5.40.1.tar.xz"
download_package "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz" "intltool-0.51.0.tar.gz"
download_package "https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.xz" "autoconf-2.72.tar.xz"
download_package "https://ftp.gnu.org/gnu/automake/automake-1.17.tar.xz" "automake-1.17.tar.xz"
download_package "https://github.com/openssl/openssl/releases/download/openssl-3.4.1/openssl-3.4.1.tar.gz" "openssl-3.4.1.tar.gz"
download_package "https://sourceware.org/ftp/elfutils/0.192/elfutils-0.192.tar.bz2" "elfutils-0.192.tar.bz2"
download_package "https://github.com/libffi/libffi/releases/download/v3.4.7/libffi-3.4.7.tar.gz" "libffi-3.4.7.tar.gz"
download_package "https://www.python.org/ftp/python/3.13.2/Python-3.13.2.tar.xz" "Python-3.13.2.tar.xz"
download_package "https://pypi.org/packages/source/f/flit-core/flit_core-3.11.0.tar.gz" "flit_core-3.11.0.tar.gz"
download_package "https://pypi.org/packages/source/w/wheel/wheel-0.45.1.tar.gz" "wheel-0.45.1.tar.gz"
download_package "https://pypi.org/packages/source/s/setuptools/setuptools-75.8.1.tar.gz" "setuptools-75.8.1.tar.gz"
download_package "https://github.com/ninja-build/ninja/archive/v1.12.1/ninja-1.12.1.tar.gz" "ninja-1.12.1.tar.gz"
download_package "https://github.com/mesonbuild/meson/releases/download/1.7.0/meson-1.7.0.tar.gz" "meson-1.7.0.tar.gz"
download_package "https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.tar.xz" "kmod-34.tar.xz"
download_package "https://ftp.gnu.org/gnu/coreutils/coreutils-9.6.tar.xz" "coreutils-9.6.tar.xz"
download_package "https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz" "check-0.15.2.tar.gz"
download_package "https://ftp.gnu.org/gnu/diffutils/diffutils-3.11.tar.xz" "diffutils-3.11.tar.xz"
download_package "https://ftp.gnu.org/gnu/gawk/gawk-5.3.1.tar.xz" "gawk-5.3.1.tar.xz"
download_package "https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz" "findutils-4.10.0.tar.xz"
download_package "https://ftp.gnu.org/gnu/groff/groff-1.23.0.tar.gz" "groff-1.23.0.tar.gz"
download_package "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz" "grub-2.12.tar.xz"
download_package "https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.xz" "gzip-1.13.tar.xz"
download_package "https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.13.0.tar.xz" "iproute2-6.13.0.tar.xz"
download_package "https://www.kernel.org/pub/linux/utils/kbd/kbd-2.7.1.tar.xz" "kbd-2.7.1.tar.xz"
download_package "https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.8.tar.gz" "libpipeline-1.5.8.tar.gz"
download_package "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz" "make-4.4.1.tar.gz"
download_package "https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz" "patch-2.7.6.tar.xz"
download_package "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz" "tar-1.35.tar.xz"
download_package "https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz" "texinfo-7.2.tar.xz"
download_package "https://github.com/vim/vim/archive/v9.1.1166/vim-9.1.1166.tar.gz" "vim-9.1.1166.tar.gz"
download_package "https://pypi.org/packages/source/M/MarkupSafe/markupsafe-3.0.2.tar.gz" "markupsafe-3.0.2.tar.gz"
download_package "https://pypi.org/packages/source/J/Jinja2/jinja2-3.1.5.tar.gz" "jinja2-3.1.5.tar.gz"
download_package "https://github.com/systemd/systemd/archive/v257.3/systemd-257.3.tar.gz" "systemd-257.3.tar.gz"
download_package "https://download.savannah.gnu.org/releases/man-db/man-db-2.13.0.tar.xz" "man-db-2.13.0.tar.xz"
download_package "https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.4.tar.xz" "util-linux-2.40.4.tar.xz"
download_package "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.2/e2fsprogs-1.47.2.tar.gz" "e2fsprogs-1.47.2.tar.gz"
download_package "https://github.com/troglobit/sysklogd/releases/download/v2.7.0/sysklogd-2.7.0.tar.gz" "sysklogd-2.7.0.tar.gz"
download_package "https://github.com/slicer69/sysvinit/releases/download/3.14/sysvinit-3.14.tar.xz" "sysvinit-3.14.tar.xz"
download_package "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz" "XML-Parser-2.47.tar.gz"
download_package "https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-4.0.5.tar.xz" "procps-ng-4.0.5.tar.xz"
download_package "https://www.linuxfromscratch.org/patches/lfs/12.3/bzip2-1.0.8-install_docs-1.patch" "bzip2-1.0.8-install_docs-1.patch"
download_package "https://www.linuxfromscratch.org/patches/lfs/12.3/coreutils-9.6-i18n-1.patch" "coreutils-9.6-i18n-1.patch"
download_package "https://www.linuxfromscratch.org/patches/lfs/12.3/expect-5.45.4-gcc14-1.patch" "expect-5.45.4-gcc14-1.patch"
download_package "https://www.linuxfromscratch.org/patches/lfs/12.3/glibc-2.41-fhs-1.patch" "glibc-2.41-fhs-1.patch"
download_package "https://www.linuxfromscratch.org/patches/lfs/12.3/kbd-2.7.1-backspace-1.patch" "kbd-2.7.1-backspace-1.patch"
download_package "https://www.linuxfromscratch.org/patches/lfs/12.3/sysvinit-3.14-consolidated-1.patch" "sysvinit-3.14-consolidated-1.patch"
download_package "https://www.iana.org/time-zones/repository/releases/tzdata2025a.tar.gz" "tzdata2025a.tar.gz"
download_package "https://anduin.linuxfromscratch.org/LFS/udev-lfs-20230818.tar.xz" "udev-lfs-20230818.tar.xz"
download_package "https://anduin.linuxfromscratch.org/LFS/systemd-man-pages-257.3.tar.xz" "systemd-man-pages-257.3.tar.xz"
download_package "https://www.linuxfromscratch.org/lfs/downloads/12.3/lfs-bootscripts-20240825.tar.xz" "lfs-bootscripts-20240825.tar.xz"
download_package "https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.13.4.tar.xz" "linux-6.13.4.tar.xz"
download_package "https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz" "libpsl-0.21.5.tar.gz"
download_package "https://curl.se/download/curl-8.12.1.tar.xz" "curl-8.12.1.tar.xz"
download_package "https://www.kernel.org/pub/software/scm/git/git-2.48.1.tar.xz" "git-2.48.1.tar.xz"
download_package "https://github.com/lfs-book/make-ca/archive/v1.15/make-ca-1.15.tar.gz" "make-ca-1.15.tar.gz"
download_package "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.45/pcre2-10.45.tar.bz2" "pcre2-10.45.tar.bz2"
download_package "https://nginx.org/download/nginx-1.28.0.tar.gz" "nginx-1.28.0.tar.gz"
download_package "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz" "libtasn1-4.20.0.tar.gz"
download_package "https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz" "p11-kit-0.25.5.tar.xz"
download_package "https://sqlite.org/2025/sqlite-autoconf-3490100.tar.gz" "sqlite-autoconf-3490100.tar.gz"
