#!/bin/bash

# Get the CoreOS kernel version we want to compile against from $release env var
kernel=$(wget -qO- https://coreos.com/releases/releases.json | \
jq --arg release $release .['$release] | ."major_software" | ."kernel"| .[0]' |
tr -d '"')

# Compilation preparation
cd /usr/src/kernels/linux
ln -s /usr/src/kernels/linux/ /usr/src/linux

# Strip .0 for kernel version tag
if [ "${kernel: -1}" -eq "0" ]; then
	kernel=$(echo $kernel | cut -d . -f -2)
fi

git checkout v$kernel
make mrproper
cp /.config .
make modules_prepare
make modules
sed -i "s/$kernel/$kernel-coreos-r1/g" include/generated/utsrelease.h

# Compilation: pf_ring kernel module
cd /opt/pfring/kernel
cp linux/pf_ring.h /usr/src/kernels/linux/include/linux/
make -C /usr/src/kernels/linux/ M=$PWD

# Compilation: pf_ring drivers
cd /opt/pfring/drivers/ZC/intel/i40e/i40e-*/src/i40e/
make -C /usr/src/kernels/linux/ M=$PWD

cd /opt/pfring/drivers/ZC/intel/igb/igb-*/src/
make -C /usr/src/kernels/linux/ M=$PWD

cd /opt/pfring/drivers/ZC/intel/e1000e/e1000e-*/src/
make -C /usr/src/kernels/linux/ M=$PWD

cd /opt/pfring/drivers/ZC/intel/ixgbe/ixgbe-*/src/
make -C /usr/src/kernels/linux/ M=$PWD


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
