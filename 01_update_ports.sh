#!/bin/sh

export CVSREADONLYFS=1

# following command allows using $0 /www/nextcloud for quickly updating one folder
cd /home/ports${1}
cvs -d /cvs -q up -Pd -A -r OPENBSD_6_6
