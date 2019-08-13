#!/bin/sh

set -e
ARCH=$(sysctl -n hw.machine)
LISTE=$(mktemp /tmp/filelist.XXXXXXXXXXXXXXXXXX)

make -C /home/ports SUBDIRLIST=~/fulllist show=PKGNAMES | grep -v "^=" | tr ' ' '\n' | sed 's,$,\.tgz,' | sort | uniq > "${LISTE}"

doas mkdir -p /mnt/packages-stable/$ARCH/ftp/
doas rsync --files-from="${LISTE}" -av /home/packages/$ARCH/ftp/ /mnt/packages-stable/$ARCH/ftp/

rm "${LISTE}"
