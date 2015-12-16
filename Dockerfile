# Dockerfile that sets up a build environment for compiling PF_RING for CoreOS
#
# On push, Travis-CI takes care of building this image, running the container,
# and pushing all of the compiled drivers to a (tagged) branch in GitHub.
# 
# Last Updated: 12/14/2015
# CoreOS Stable: 835.9.0
# CoreOS Beta: 877.1.0
# CoreOS Alpha: 891.0.0
#
# This Dockerfile is just for the pf_ring kernel module/driver build automation.
# Another container (e.g. snort, suricata, bro, etc.), should pull down said
# precompiled modules at runtime and activate them using 'insmod'.
#

FROM debian:jessie
MAINTAINER Walter Meyer <wgmeyer@gmail.com>

# PF_RING Version
ENV pf_ring_version 6.2.0-stable

# Setup environment
RUN apt-get -y update && apt-get -y \
	install gcc-4.9 bc wget jq git make dpkg-dev module-init-tools && \
    mkdir -p /usr/src/kernels && \
    mkdir -p /opt/pfring && \
    apt-get autoremove && apt-get clean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 10

# Download kernel source
RUN cd /usr/src/kernels && \
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux

# Get pfring source
RUN git clone https://github.com/ntop/PF_RING.git /opt/pfring && \
	cd /opt/pfring && git checkout -b $pf_ring_version

ADD .config /.config
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
