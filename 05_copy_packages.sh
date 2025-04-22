#!/bin/ksh -e

ARCH=$(machine -a)
FILELIST=$(mktemp /tmp/filelist.XXXXXXXX)

SUBDIRLIST=~/fulllist make -C /home/ports show=PKGNAMES |
	grep -v "^=" | grep ^. | tr ' ' '\n' | sed 's,$,\.tgz,' |
	sort | uniq > $FILELIST

doas mkdir -p /mnt/packages-stable/$ARCH/ftp/
doas rsync --files-from=$FILELIST -av /home/packages/$ARCH/ftp/ \
	/mnt/packages-stable/$ARCH/ftp/ | tee -a config/rsync_output

rm $FILELIST
