#!/bin/sh

# Get the CoreOS kernel version we want to compile against from $release env var
kernel=$(wget -qO- https://coreos.com/releases/releases.json | \
jq --arg release $release .['$release] | ."major_software" | ."kernel"| .[0]' |
tr -d '"')

# Compilation preparation
cd /usr/src/kernels/linux
git checkout -b stable v$kernel
zcat /proc/config.gz > .config
make modules_prepare
sed -i "s/$kernel/$kernel-coreos-r1/g" include/generated/utsrelease.h
mkdir -p /lib/modules/$kernel-coreos-r1/
ln -s /usr/src/kernels/linux/ /lib/modules/$kernel-coreos-r1/build

# Compilation: pf_ring kernel module
cd /opt/pfring/kernel && make

# Compilation: pf_ring drivers
cd /opt/pfring/drivers/ZC && make

# Output directories
mkdir -p /builds/kernel/
mkdir -p /builds/drivers/ZC/intel/e1000e/
mkdir -p /builds/drivers/ZC/intel/igb/
mkdir -p /builds/drivers/ZC/intel/ixgbe/
mkdir -p /builds/drivers/ZC/intel/i40e/

# kernel
cp /opt/pfring/kernel/pf_ring.ko /builds/kernel/
# e1000e
cp /opt/pfring/drivers/ZC/intel/e1000e/e1000e-*/src/e1000e.ko /builds/drivers/ZC/intel/e1000e/
# igb
cp /opt/pfring/drivers/ZC/intel/igb/igb-*/src/igb.ko /builds/drivers/ZC/intel/igb/
# ixgbe
cp /opt/pfring/drivers/ZC/intel/ixgbe/ixgbe-*/src/ixgbe.ko /builds/drivers/ZC/intel/ixgbe/
# i40e
cp /opt/pfring/drivers/ZC/intel/i40e/i40e-*/src/i40e/i40e.ko /builds/drivers/ZC/intel/i40e/
