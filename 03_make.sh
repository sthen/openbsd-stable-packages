#!/bin/sh

set -x
LOGDIR="/mnt/logs-stable/$(date +%Y%m%d-%H%M)"

doas mkdir -p $LOGDIR

for port in $(cat /home/builder/pkgliste)
do
	PORTPATH=$(echo $port | sed 's,/,_,g')
	cd /usr/ports/${port} || exit 1
	make BULK=yes FETCH_PACKAGE= package | doas tee "${LOGDIR}/${PORTPATH}.log"
done



for logs in /mnt/logs-stable/*tar.gz
do
	FOLDER=$(echo $logs | sed 's/\.tar\.gz//')
	test -d "$FOLDER" && doas rm -fr "$FOLDER"
done
	

# compress logs
doas tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
