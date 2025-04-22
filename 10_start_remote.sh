#!/bin/ksh

PATHLIST=$(cut -d '/' -f 1-2 config/tmppkgliste | sort | uniq | tr '\n' ' ')

# fetch distfiles to avoid issues
cd /home/ports
env SUBDIRLIST=~/fulllist BULK=yes make fetch

for arch in amd64 i386; do
	REMOTE=builder@${arch}-stable.ports.openbsd.org
	if [[ $arch != amd64 ]]; then
		scp config/{in,ex}clude.txt ${REMOTE}:scripts/config/
		scp ~/fulllist ${REMOTE}:
		# XXX should use shared tree
		ssh ${REMOTE} "cd scripts && ./01_update_ports.sh"
	fi
	ssh ${REMOTE} "cd scripts &&
		./03_clean_packages.sh && ./04_make.sh &&
		./05_copy_packages.sh" &
done

wait

echo "finished"
