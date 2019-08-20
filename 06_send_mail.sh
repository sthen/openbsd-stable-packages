#!/bin/sh

ARCH=$(uname -p)

test -f config/rsync_output && grep tgz$ config/rsync_output >/dev/null
if [ $? -ne 0 ]
then
	echo "No package, no mail."
	exit 0
fi

set -x
{
	printf "Hello. New package(s) to sign for ${ARCH}-stable.\n\n---\n"
	grep tgz$ config/rsync_output
	printf "---\n"
} | mail -s "${ARCH}-stable packages to sign" -r solene@openbsd.org solene@openbsd.org

#rm config/rsync_output
