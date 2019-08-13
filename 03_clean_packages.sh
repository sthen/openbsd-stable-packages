#!/bin/sh

doas pkg_delete -X intel-firmware vmm-firmware

doas pkg_add rsync-- sqlports-- git--
