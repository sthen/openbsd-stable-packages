#!/bin/sh

ARCH=$(sysctl -n hw.machine)
LISTE=$(mktemp /tmp/filelist.XXXXXXXXXXXXXXXXXX)

find /home/packages/$ARCH/ftp -newer /home/packages/$ARCH/all/SHA256 -type f > "${LISTE}"

doas mkdir -p /mnt/packages-stable/$ARCH/ftp/
doas rsync --no-relative --files-from="${LISTE}" -av / /mnt/packages-stable/$ARCH/ftp/

rm "${LISTE}"
