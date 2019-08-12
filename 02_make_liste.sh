#!/bin/sh

DESTLIST=/home/builder/fulllist
TMPLIST=config/tmppkgliste

rm -f $TMPLIST
rm -f $DESTLIST

# make the list of changed packages (excluding firmwares and folders like "lang/php/")
# grep only keep ports where the makefile changed
# sed will format display
# awk removes folder categories
cvs -d /cvs rdiff -s  -r OPENBSD_6_5_BASE -r OPENBSD_6_5 ports/ 2>/dev/null | \
	grep -E '/Makefile(.inc)? ' | \
	sed -E 's,^File ports/(.*)/Makefile(.inc)? .*,\1,' | \
	grep -v "^sysutils/firmware" | \
	awk '{
		if(NR==1) {
			line=$0
		} else {
			if(index($0,line"/")==0) {
				print line
			}
			line=$0
		}
	}
	END {
		print line
	}' > $TMPLIST


for port in $(cat $TMPLIST)
do
	printf "SELECT DISTINCT fullpkgpath from ports where fullpkgpath like '%s' or  fullpkgpath like '%s,%%'" "$port"  "$port" | sqlite3 /usr/local/share/sqlports >> $DESTLIST
done
