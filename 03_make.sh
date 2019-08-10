#!/bin/sh

set -x
LOGDIR="/mnt/logs-stable/$(date +%Y%m%d-%H%M)"
LIST=$(mktemp /tmp/packagename.XXXXXXXXXXXXXXX)

doas mkdir -p $LOGDIR

cd /home/ports
set -e

for port in $(cat /home/builder/fulllist)
do
	PORTPATH=$(echo $port | sed 's,/,_,g')
	echo $port > $LIST
	make SUBDIRLIST=$LIST BULK=yes FETCH_PACKAGE= package | doas tee "${LOGDIR}/${PORTPATH}.log"
done


for logs in /mnt/logs-stable/*tar.gz
do
	FOLDER=$(echo $logs | sed 's/\.tar\.gz//')
	test -d "$FOLDER" && doas rm -fr "$FOLDER"
done
	

# compress logs
doas tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
