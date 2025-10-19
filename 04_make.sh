#!/bin/ksh -e

ARCH=$(machine -a)
LOGDIR="/mnt/logs-stable/${ARCH}/$(date +%Y%m%d-%H%M)"
mkdir -p $LOGDIR
chmod g+w $LOGDIR

doas env PKG_PATH=/home/packages/$ARCH/all pkg_add -r -D unsigned glib2

cd /home/ports

# export REPORT_PROBLEM=/home/builder/scripts/error_handler.sh
#export REPORT_PROBLEM=true
export REPORT_PROBLEM_LOGFILE=$LOGDIR/ZZ-build-problems

SUBDIRLIST=~/fulllist make package \
	BULK=yes PKG_PATH=/var/empty FETCH_PACKAGES= 2>&1 | \
	/home/ports/infrastructure/bin/portslogger $LOGDIR > /dev/null

for i in devel/quirks databases/updatedb; do
	cd /home/ports/$i
	make clean=all
	make REPORT_PROBLEM=~/scripts/error_handler.sh BULK=yes package 2>&1 | \
		/home/ports/infrastructure/bin/portslogger $LOGDIR
done

cat $LOGDIR/ZZ-build-problems

# compress and remove old logs
tar czvf "${LOGDIR}.tar.gz" "${LOGDIR}"
find /mnt/logs-stable/${ARCH} -type d -mindepth 1 -maxdepth 1 -mtime +21 -exec {} +
