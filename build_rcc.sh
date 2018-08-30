#!/bin/sh

# for example:
#     ../qemu/build_rcc.sh [debug|release]

debug=""
if [ "$1" = "" ]; then
    debug="no"
elif [ "$1" = "release" ]; then
    debug="no"
elif [ "$1" = "debug" ]; then
    debug="yes"
    echo "in debug mode"
fi

self_path="`pwd`/$0"
src_path=`dirname "$self_path"`

configure="$src_path/configure"
if [ ! -f "$configure" ]; then
    echo "\"$configure\" is not exist."
    exit
fi

config_args=""
# platform
config_args="$config_args --target-list=x86_64-softmmu --enable-kvm --enable-system --disable-user --disable-xen --disable-xen-pci-passthrough"
# build
config_args="$config_args --enable-pie --prefix=/usr --with-coroutine=ucontext --enable-coroutine-pool --disable-docs"
# debug
config_args="$config_args --disable-debug-tcg"
# display
config_args="$config_args --enable-spice --enable-vnc --disable-sdl --disable-gtk --disable-vnc-sasl --disable-vnc-png"
# usb
config_args="$config_args --enable-usb-redir --disable-libusb"
# net
config_args="$config_args --enable-vhost-net --disable-vde --disable-netmap"
# block
config_args="$config_args --disable-virtfs --disable-linux-aio --disable-libiscsi --disable-libnfs --enable-vhdx --disable-glusterfs"
# other
config_args="$config_args --disable-cocoa --disable-brlapi --disable-curl --disable-fdt --disable-bluez --disable-rdma --disable-cap-ng --disable-lzo --disable-snappy"
config_args="$config_args --disable-guest-agent --disable-seccomp --disable-tpm --disable-curses"
config_args="$config_args --enable-uuid --enable-attr --enable-numa"

# generate building version
src_git="$src_path/.git"
git_hash=`git --git-dir=$src_git log --oneline -1 | awk '{print $1}'`
pkgversion="RCC-$git_hash-`date +%G%m%d%H%M%S`"
config_args="$config_args --with-pkgversion=$pkgversion"

# debug building
if [ "$debug" = "yes" ]; then
    config_args="$config_args --enable-debug"
fi

cmd="$configure $config_args"
echo "$cmd"
exec $cmd
