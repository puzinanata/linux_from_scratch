#!/bin/bash

pushd /etc/sysconfig/
cat > ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.123.2
GATEWAY=192.168.123.1
PREFIX=24
BROADCAST=192.168.123.255
EOF

popd

cat > /etc/resolv.conf << "EOF"

nameserver 8.8.8.8

EOF

echo "lfs" > /etc/hostname


cat > /etc/hosts << "EOF"

127.0.0.1 localhost.localdomain localhost
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

EOF