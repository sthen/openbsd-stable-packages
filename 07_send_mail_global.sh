#!/bin/ksh

ARCHS="amd64 i386"

# fetch rsync output files
for arch in $ARCHS
do
	REMOTE=builder@${arch}-stable.ports.openbsd.org
	scp $REMOTE:scripts/config/rsync_output /tmp/${arch}_output.txt
done

grep tgz$ /tmp/*_output.txt
if [ $? -ne 0 ]
then
	echo "No package ?!" | mail -s "no package stable" stu@spacehopper.org
	exit 1
fi

# generate some build stats for the mail
{
        printf "Hello. New package(s) to sign.\n\n---\n"

	# count number of packages per arch
	for arch in $ARCHS
	do
		printf "%-8s %3i + %3i -debug packages\n" \
	"$arch" \
	"$(grep tgz$ /tmp/${arch}_output.txt | grep -Ev '^(quirks|updatedb)' | grep -v ^debug- | sort | uniq | wc -l | awk '{ print $1 }')" \
	"$(grep tgz$ /tmp/${arch}_output.txt | grep -Ev '^(quirks|updatedb)' | grep ^debug- | sort | uniq | wc -l | awk '{ print $1 }')"
	done
        printf "---\n"

	# list every file built per arch with the arch as a beginning of lines
	for arch in $ARCHS
	do
		grep tgz$ /tmp/${arch}_output.txt | grep -Ev '^(quirks|updatedb)' | sort | uniq | sed "s,^,$arch	,"
	done

        printf "\nChanges triggering the build:\n"
        cat /home/builder/scripts/config/changes.txt

} | mail -s "stable packages to sign" -r "Stable <sthen@openbsd.org>" stu@spacehopper.org pea@openbsd.org naddy@openbsd.org

# clear the remotes rsync output file
for arch in $ARCHS
do
	REMOTE=builder@${arch}-stable.ports.openbsd.org
	ssh $REMOTE "rm /home/builder/scripts/config/rsync_output"
done
