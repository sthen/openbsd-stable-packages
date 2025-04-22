#!/bin/ksh

export CVSREADONLYFS=1
DESTLIST=~/fulllist
TMPLIST=config/tmppkgliste

rm -f $TMPLIST
rm -f $DESTLIST

# make the list of changed packages (excluding firmwares and folders like "lang/php/")
# grep only keep ports where the makefile changed
# sed will format display
# awk removes folder categories
cvs -d /cvs rdiff -s  -r OPENBSD_7_7_BASE -r OPENBSD_7_7 ports/ 2>/dev/null | \
	grep -E '/(distinfo|Makefile(.inc)?) ' | \
	sed -E 's,^File ports/(.*)/(distinfo|Makefile(.inc)?) .*,\1,' | \
	grep -v "^sysutils/firmware" | sort | uniq | \
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
	printf "SELECT DISTINCT fullpkgpath from ports where fullpkgpath like '%s' or  fullpkgpath like '%s,%%' or fullpkgpath like '%s/%%'" "$port"  "$port" "$port" | sqlite3 /usr/local/share/sqlports >> $DESTLIST
done

cat config/include.txt $DESTLIST | grep -v '^$' | sort | uniq > ${DESTLIST}.new
mv ${DESTLIST}.new $DESTLIST
echo "devel/quirks" >> $DESTLIST
echo "databases/updatedb" >> $DESTLIST
