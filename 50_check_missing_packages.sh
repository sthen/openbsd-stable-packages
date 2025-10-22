#!/bin/sh

export CVSREADONLYFS=1

TMPLIST=config/tmppkglist
TMPFILE=$(mktemp /tmp/file.XXXXXXXXXXXXXXXXXXXXXXXX)


for port in $(cat $TMPLIST)
do
	for dep in $(printf "SELECT DISTINCT fullpkgpath from ports where fullpkgpath like '%s' and not pkgspec LIKE '%%*' ;" "$port" | sqlite3 /usr/local/share/sqlports)
	do
		show-reverse-deps "$dep" >> $TMPFILE
	done
done

echo "pkgpath that should be included or excluded (if any)"
cat config/{include,exclude}.txt $TMPFILE | sort | uniq -u
