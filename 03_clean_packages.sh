#!/bin/sh

doas pkg_delete -X intel-firmware vmm-firmware
doas env TRUSTED_PKG_PATH=/home/packages/$(arch -s)/all/ pkg_add rsync-- sqlports-- git-- ccache
doas -u _pbuild rm -fr /build/tmp/pobj
doas mkdir -p /build/tmp/pobj
doas chown _pbuild /build/tmp/pobj
