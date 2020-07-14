#!/bin/sh

if [ "$(pgrep -f "^sh cron\.sh$" | grep -v $$)" -ne 0 ]
then
	echo "$0 is already running"
	exit 0
fi

LINES=$(./01_update_ports.sh | wc -l | awk '{ print $1 }')

if [ "$LINES" -ne 0 ]
then
	set -x
	./02_make_liste.sh
	set -e
	./10_start_remote.sh
	./07_send_mail_global.sh
else
	echo "nothing to do"
fi
