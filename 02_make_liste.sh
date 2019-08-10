#!/bin/sh

DESTLIST=/home/builder/fulllist

rm -f $DESTLIST

for port in $(cat /home/builder/pkgliste)
do
	printf "SELECT DISTINCT fullpkgpath from ports where fullpkgpath like '%s' or  fullpkgpath like '%s,%%'" "$port"  "$port" | sqlite3 /usr/local/share/sqlports >> $DESTLIST
done
