#!/bin/sh

set -e

ARCH=$(machine -a)
LOGDIR="/mnt/logs-stable/${ARCH}/$(date +%Y%m%d-%H%M)"

doas mkdir -p $LOGDIR

cd /home/ports


env SUBDIRLIST=~/fulllist BULK=yes make package 2>&1 | doas /home/ports/infrastructure/bin/portslogger $LOGDIR


for logs in /mnt/logs-stable/${ARCH}/*tar.gz
do
	FOLDER=$(echo $logs | sed 's/\.tar\.gz//')
	test -d "$FOLDER" && doas rm -fr "$FOLDER"
done

# compress logs
doas tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
