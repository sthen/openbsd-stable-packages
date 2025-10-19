#!/bin/ksh -e

ARCH=$(machine -a)
LOGDIR="/mnt/logs-stable/${ARCH}/$(date +%Y%m%d-%H%M)"

doas mkdir -p $LOGDIR

cd /home/ports

# export REPORT_PROBLEM=/home/builder/scripts/error_handler.sh
export REPORT_PROBLEM=true

doas env PKG_PATH=/home/packages/$ARCH/all pkg_add -r -D unsigned glib2

SUBDIRLIST=~/fulllist make package \
	BULK=yes PKG_PATH=/var/empty FETCH_PACKAGES= 2>&1 | \
	doas /home/ports/infrastructure/bin/portslogger $LOGDIR

for i in devel/quirks databases/updatedb; do
	cd /home/ports/$i
	make clean=all
	make REPORT_PROBLEM=~/scripts/error_handler.sh BULK=yes package | \
		doas /home/ports/infrastructure/bin/portslogger $LOGDIR
done

for logs in /mnt/logs-stable/${ARCH}/*tar.gz
do
	DIR=${logs%.tar.gz}
	test -d "$DIR" && doas rm -fr "$FOLDER"
done

# compress logs
doas tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
