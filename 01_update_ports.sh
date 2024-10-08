#!/bin/sh

export CVSREADONLYFS=1

# pkgpaths can be passed as parameter to only update specific folders
cd /home/ports
cvs -d /cvs -q up -Pd -A -r OPENBSD_7_6 $*
