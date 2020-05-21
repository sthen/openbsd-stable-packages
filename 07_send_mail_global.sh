#!/bin/sh

ARCHS="amd64 i386 arm64"

# fetch rsync output files
for arch in $ARCHS
do
	REMOTE=builder@${arch}-stable.ports.openbsd.org
	scp $REMOTE:scripts/config/rsync_output /tmp/${arch}_output.txt
done

# generate some build stats for the mail
{
        printf "Hello. New package(s) to sign.\n\n---\n"

	# count number of packages per arch
	for arch in $ARCHS
	do
		printf "%-8s %3i + %3i -debug packages\n" \
	"$arch" \
	"$(grep tgz$ /tmp/${arch}_rsync.txt | grep -v ^debug- | sort | uniq | wc -l | awk '{ print $1 }')" \
	"$(grep tgz$ /tmp/${arch}_rsync.txt | grep ^debug- | sort | uniq | wc -l | awk '{ print $1 }')"
	done
        printf "---\n"

	# list every file built per arch with the arch as a beginning of lines
	for arch in $ARCHS
	do
		grep tgz$ /tmp/${arch}_rsync.txt  | sort | uniq | sed "s,^,$arch	,"
	done

} | mail -s "stable packages to sign" -r "Stable <solene@openbsd.org>" solene@openbsd.org sthen@openbsd.org pea@openbsd.org naddy@openbsd.org 

# clear the remotes rsync output file
for arch in $ARCHS
do
	REMOTE=builder@${arch}-stable.ports.openbsd.org
	ssh $REMOTE "rm /home/builder/scripts/config/rsync_output"
done
