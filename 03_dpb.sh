#!/bin/sh

set -x
LOGDIR="/mnt/logs-stable/$(date +%Y%m%d)"

#doas /build/usr/ports/infrastructure/bin/dpb -B /build/ -D LOGDIR="${LOGDIR}" -D FTP_ONLY=1 -D CONTROL=/tmp/dpb.sock -A amd64 -R -a

# using a list
doas /build/usr/ports/infrastructure/bin/dpb -B /build/ -D LOGDIR="${LOGDIR}" -D FTP_ONLY=1 -D CONTROL=/tmp/dpb.sock -A amd64 -P pkgliste

for logs in /mnt/logs-stable/*tar.gz
do
	FOLDER=$(echo $logs | sed 's/\.tar\.gz//')
	echo $FOLDER
done
	

# compress logs
doas tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
