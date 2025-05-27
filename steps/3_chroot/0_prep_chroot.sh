#!/bin/bash

set -e
set -x

PACKAGE_CACHE=/var/lib/lfs
mkdir -pv "$PACKAGE_CACHE"

download_package() {
  local PACKAGE_URL="$1"
  local PACKAGE_NAME="$2"
  local PACKAGE_NAME="$3"
  local PACKAGE_NAME="$4"
  local PACKAGE_NAME="$5"
  local PACKAGE_NAME="$6"

  pushd "$PACKAGE_CACHE"

  if [ ! -f "$PACKAGE_NAME" ]; then
    echo ">>> Downloading $PACKAGE_NAME ..."
    curl -LO "$PACKAGE_URL"
  else
    echo ">>> $PACKAGE_NAME already exists. Skipping download."
  fi

  popd
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
