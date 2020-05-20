#!/bin/sh

set -e
ARCH=$(machine -a)
LISTE=$(mktemp /tmp/filelist.XXXXXXXXXXXXXXXXXX)

env SUBDIRLIST=~/fulllist show=PKGNAMES make -C /home/ports | grep -v "^=" | grep ^. | tr ' ' '\n' | sed 's,$,\.tgz,' | sort | uniq > "${LISTE}"

doas mkdir -p /mnt/packages-stable/$ARCH/ftp/
doas rsync --files-from="${LISTE}" -av /home/packages/$ARCH/ftp/ /mnt/packages-stable/$ARCH/ftp/ | tee -a config/rsync_output


rm "${LISTE}"
