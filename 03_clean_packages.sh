#!/bin/sh

doas pkg_delete -X intel-firmware vmm-firmware

doas env TRUSTED_PKG_PATH=/home/packages/$(arch -s)/all/ pkg_add rsync-- sqlports-- git-- ccache

test -d /build/tmp/pobj && doas rm -fr /build/tmp/pobj/*
