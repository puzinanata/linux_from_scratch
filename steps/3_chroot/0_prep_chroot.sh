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

# Package 7: man-pages
download_package "https://www.kernel.org/pub/linux/docs/man-pages/man-pages-6.12.tar.xz" "man-pages-6.12.tar.xz"

# Package 8: Iana-etc
download_package "https://github.com/Mic92/iana-etc/releases/download/20250123/iana-etc-20250123.tar.gz" "iana-etc-20250123.tar.gz"

# Package 9: glibc
download_package "https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz" "glibc-2.41.tar.xz"

# Package 10: zlib
download_package "https://zlib.net/fossils/zlib-1.3.1.tar.gz" "zlib-1.3.1.tar.gz"

# Package 11: bzip
download_package "https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz" "bzip2-1.0.8.tar.gz"

# Package 12: xz
download_package "https://github.com//tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.xz" "xz-5.6.4.tar.xz"

# Package 13: lz4
download_package "https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz" "lz4-1.10.0.tar.gz"

# Package 14: zstd
download_package "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz" "zstd-1.5.7.tar.gz"

# Package 15: file
download_package "https://astron.com/pub/file/file-5.46.tar.gz" "file-5.46.tar.gz"

# Package 16: readline
download_package "https://ftp.gnu.org/gnu/readline/readline-8.2.13.tar.gz" "readline-8.2.13.tar.gz"

