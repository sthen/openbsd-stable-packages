#!/bin/sh

LISTE=$(mktemp /tmp/filelist.XXXXXXXXXXXXXXXXXX)

find /build/data/packages/amd64/ftp -newer /build/data/packages/amd64/all/SHA256 -type f > "${LISTE}"

doas mkdir -p /mnt/packages-stable/amd64/ftp/
doas rsync --no-relative --files-from="${LISTE}" -av / /mnt/packages-stable/amd64/ftp/

rm "${LISTE}"
