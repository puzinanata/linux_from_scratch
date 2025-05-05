#!/bin/bash

#ssh puzinanata@192.168.1.70

cd
curl -LO 'http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.bz2'

md5_actual=$(md5sum binutils-2.25.tar.bz2 | awk '{ print $1 }')

if [[ "$md5_actual" == "d9f3303f802a5b6b0bb73a335ab89d66" ]]; then
    tar -xjf binutils-2.25.tar.bz2
    echo "unpacked successfully."
else
    echo "MD5 mismatch!"
fi


