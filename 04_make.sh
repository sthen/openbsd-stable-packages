#!/bin/sh

set -e

ARCH=$(machine -a)
LOGDIR="/mnt/logs-stable/${ARCH}/$(date +%Y%m%d-%H%M)"

doas mkdir -p $LOGDIR

cd /home/ports

# export REPORT_PROBLEM=/home/builder/scripts/error_handler.sh
export REPORT_PROBLEM=true

env SUBDIRLIST=~/fulllist BULK=yes PKG_PATH=/var/empty make package FETCH_PACKAGES= 2>&1 | doas /home/ports/infrastructure/bin/portslogger $LOGDIR
cd /home/ports/devel/quirks && make clean=all && make REPORT_PROBLEM=/home/builder/scripts/error_handler.sh BULK=yes package | doas /home/ports/infrastructure/bin/portslogger $LOGDIR
cd /home/ports/databases/updatedb && make clean=all && make REPORT_PROBLEM=/home/builder/scripts/error_handler.sh BULK=yes package | doas /home/ports/infrastructure/bin/portslogger $LOGDIR


for logs in /mnt/logs-stable/${ARCH}/*tar.gz
do
	FOLDER=$(echo $logs | sed 's/\.tar\.gz//')
	test -d "$FOLDER" && doas rm -fr "$FOLDER"
done

# compress logs
doas tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
