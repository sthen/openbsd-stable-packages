#!/bin/sh

PATHLIST=$(cut -d '/' -f 1-2 config/tmppkgliste | sort | uniq | tr '\n' ' ')

for arch in sparc64 amd64 i386 arm64; do
	REMOTE=builder@${arch}-stable.ports.openbsd.org
	scp config/*clude.txt ${REMOTE}:scripts/config/
	scp ~/fulllist ${REMOTE}:
	ssh ${REMOTE} "cd scripts && ./01_update_ports.sh $PATHLIST && ./03_clean_packages.sh && ./04_make.sh && ./05_copy_packages.sh" &
done

wait

echo "finished"
