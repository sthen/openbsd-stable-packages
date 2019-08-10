#!/bin/sh

export CVSREADONLYFS=1
cd /home/ports
cvs -d /cvs -q up -Pd -A -r OPENBSD_6_5
