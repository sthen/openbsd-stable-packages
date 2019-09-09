#!/bin/sh

doas pkg_delete -X intel-firmware vmm-firmware

doas pkg_add rsync-- sqlports-- git--

test -d /build/tmp/pobj && doas rm -fr /build/tmp/pobj/*
