[![Build Status](https://travis-ci.org/waltermeyer/pfring-coreos.svg)](https://travis-ci.org/waltermeyer/pfring-coreos)


[CoreOS Stable 835.9.0 Stable](https://github.com/waltermeyer/pfring-coreos/tree/835.9.0/builds)

[CoreOS Beta 877.1.0 Stable](https://github.com/waltermeyer/pfring-coreos/tree/877.1.0/builds)

[CoreOS Alpha 891.0.0 Stable](https://github.com/waltermeyer/pfring-coreos/tree/891.0.0/builds)

The purpose of this project is to automate the compilation [PF_RING](http://www.ntop.org/products/packet-capture/pf_ring/pf_ring-zc-zero-copy/) kernel module and the PF_RING zero-copy NIC drivers for CoreOS.

Specifically, I use TravisCI and Docker to build against whatever version of the Kernel the CoreOS release channel (Stable, Beta, Alpha) in question is on.

This work should be adaptable so that you can use it to automate building other out of tree kernel modules for CoreOS. CUDA, etc.

To use this, you can probably do a few things:

1. Grab the compiled modules that you need directly and install them on your CoreOS host using insmod pf_ring.ko etc. Remember, CoreOS modules do not persist across reboots or updates on CoreOS, so you should handle that, maybe using approach #2 below.

2. Have a docker entrypoint script that pulls down the compiled modules/drivers from this repo and insert them at runtime using insmod filename.ko. E.g. if you had a Snort Docker container that ran on CoreOS, you could do the module insertion at startup before your Snort process starts.

I will add more documention, examples, and use cases later.
