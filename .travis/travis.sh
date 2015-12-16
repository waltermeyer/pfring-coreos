#!/bin/sh

wget http://stable.release.core-os.net/amd64-usr/$RELEASE/coreos_developer_container.bin.bz2
bunzip2 coreos_developer_container.bin.bz2
sudo kpartx -asv coreos_developer_container.bin
LOOPDEV=$(sudo kpartx -asv coreos_developer_container.bin | cut -d\  -f 3)
sudo mkdir /tmp/loop || true
sudo mount /dev/mapper/$LOOPDEV /tmp/loop
cp /tmp/loop/usr/boot/config-* .
sudo umount /tmp/loop
sudo kpartx -dv coreos_developer_container.bin
rm -rf coreos_developer_container.bin
cp config-* .config