#!/bin/ksh

if [[ $(pgrep -f "^sh cron\.sh" | grep -v $$) -ne 0 ]]
then
	echo "$0 is already running"
	exit 0
fi

if [[ $# -ne 1 ]]; then
	LINES=$(./01_update_ports.sh |
		tee /home/builder/scripts/config/changes.txt | wc -l)
else
	echo "Forcing"
	LINES=1
fi

if [[ $LINES -ne 0 ]]; then
	./02_make_liste.sh
	set -e
	./10_start_remote.sh
	./07_send_mail_global.sh
        exec sh cron.sh
else
	: # echo "nothing to do"
fi
