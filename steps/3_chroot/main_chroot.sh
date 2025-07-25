#!/bin/bash

set -e
set -x

echo ">>> Inside chroot environment"

# Init variables
JOBS=$(nproc)
PACKAGE_CACHE=/var/lib/lfs
BUILD_DIR=/build
mkdir -pv $BUILD_DIR

# Create basic directory layout
mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/lib/locale
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

# Symlinks (skip if already correctly linked)
[ -L /var/run ] || ln -svf /run /var/run
[ -L /var/lock ] || ln -svf /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

# Only create /etc/mtab if it doesn't exist
[ -e /etc/mtab ] || ln -sv /proc/self/mounts /etc/mtab

# Create /etc/hosts if missing
[ -f /etc/hosts ] || cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF

# Create basic passwd/group only if they don't exist
[ -f /etc/passwd ] || cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF

[ -f /etc/group ] || cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

# Optional test user setup
if ! grep -q "^tester:" /etc/passwd; then
  echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
  echo "tester:x:101:" >> /etc/group
  install -o tester -d /home/tester || true
fi

# Create log files if not already present
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog || true
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

echo ">>> Basic system chroot prepared"

source /root/chroot_scripts/1_gettext.sh
source /root/chroot_scripts/2_bison.sh
source /root/chroot_scripts/3_perl.sh
source /root/chroot_scripts/4_python.sh
source /root/chroot_scripts/5_texinfo.sh
source /root/chroot_scripts/6_util_linux.sh
source /root/chroot_scripts/7_clean.sh
source /root/chroot_scripts/8_manpages.sh
source /root/chroot_scripts/9_iana_etc.sh
source /root/chroot_scripts/10_glibc.sh
source /root/chroot_scripts/11_zlib.sh
source /root/chroot_scripts/12_bzip.sh
source /root/chroot_scripts/13_xz.sh
source /root/chroot_scripts/14_lz4.sh
source /root/chroot_scripts/15_zstd.sh
source /root/chroot_scripts/16_file.sh
source /root/chroot_scripts/17_readline.sh
source /root/chroot_scripts/18_m4.sh
source /root/chroot_scripts/19_bc.sh
source /root/chroot_scripts/20_flex.sh
source /root/chroot_scripts/21_tcl.sh
source /root/chroot_scripts/22_expect.sh
source /root/chroot_scripts/23_dejagnu.sh
source /root/chroot_scripts/24_pkgconf.sh
source /root/chroot_scripts/25_binutils.sh
source /root/chroot_scripts/26_gmp.sh
source /root/chroot_scripts/27_mpfr.sh
source /root/chroot_scripts/28_mpc.sh
source /root/chroot_scripts/29_attr.sh
source /root/chroot_scripts/30_acl.sh
source /root/chroot_scripts/31_libcap.sh
source /root/chroot_scripts/32_libxcrypt.sh
source /root/chroot_scripts/33_shadow.sh
source /root/chroot_scripts/34_gcc.sh
source /root/chroot_scripts/35_ncurses.sh
source /root/chroot_scripts/36_sed.sh
source /root/chroot_scripts/37_psmisc.sh
source /root/chroot_scripts/38_gettext.sh
source /root/chroot_scripts/39_bison.sh
source /root/chroot_scripts/40_grep.sh
source /root/chroot_scripts/41_bash.sh
source /root/chroot_scripts/42_libtool.sh
source /root/chroot_scripts/43_gdbm.sh
source /root/chroot_scripts/44_gperf.sh
source /root/chroot_scripts/45_expat.sh
source /root/chroot_scripts/46_inetutils.sh
source /root/chroot_scripts/47_less.sh
source /root/chroot_scripts/48_perl.sh
source /root/chroot_scripts/49_parser.sh
source /root/chroot_scripts/50_intltool.sh
source /root/chroot_scripts/51_autoconf.sh
source /root/chroot_scripts/52_automake.sh
source /root/chroot_scripts/53_openssl.sh
source /root/chroot_scripts/54_libelf.sh
source /root/chroot_scripts/55_libffi.sh
source /root/chroot_scripts/56_python.sh
source /root/chroot_scripts/57_flitcore.sh
source /root/chroot_scripts/58_wheel.sh
source /root/chroot_scripts/59_setuptools.sh
source /root/chroot_scripts/60_ninja.sh
source /root/chroot_scripts/61_meson.sh
source /root/chroot_scripts/62_kmod.sh
source /root/chroot_scripts/63_coreutils.sh
source /root/chroot_scripts/64_check.sh
source /root/chroot_scripts/65_diffutils.sh
source /root/chroot_scripts/66_gawk.sh
source /root/chroot_scripts/67_findutils.sh
source /root/chroot_scripts/68_groff.sh
source /root/chroot_scripts/69_grub.sh
source /root/chroot_scripts/70_gzip.sh
source /root/chroot_scripts/71_iproot.sh
source /root/chroot_scripts/72_kbd.sh
source /root/chroot_scripts/73_libpipeline.sh
source /root/chroot_scripts/74_make.sh
source /root/chroot_scripts/75_patch.sh
source /root/chroot_scripts/76_tar.sh
source /root/chroot_scripts/77_texinfo.sh
source /root/chroot_scripts/78_vim.sh
source /root/chroot_scripts/79_markupsafe.sh
source /root/chroot_scripts/80_jinja.sh
source /root/chroot_scripts/81_udev.sh
source /root/chroot_scripts/82_mandb.sh
source /root/chroot_scripts/83_procpsng.sh
source /root/chroot_scripts/84_utillinux.sh
source /root/chroot_scripts/85_e2fsprogs.sh
source /root/chroot_scripts/86_sysklogd.sh
source /root/chroot_scripts/87_sysvinit.sh
source /root/chroot_scripts/88_cleaning.sh
source /root/chroot_scripts/89_bootscript.sh
source /root/chroot_scripts/90_manage_devices.sh
source /root/chroot_scripts/91_network_config.sh
source /root/chroot_scripts/92_config.sh
source /root/chroot_scripts/93_linux.sh

#installation BLFS packages to run my project git_log_viz
source /root/chroot_scripts/94_libpsl.sh
source /root/chroot_scripts/95_curl.sh
source /root/chroot_scripts/96_git.sh
source /root/chroot_scripts/97_libtasn.sh
source /root/chroot_scripts/98_p11kit.sh
source /root/chroot_scripts/99_make_ca.sh
source /root/chroot_scripts/100_sqlite.sh
source /root/chroot_scripts/101_python.sh












