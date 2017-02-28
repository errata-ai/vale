#!/bin/bash
set -e
cd $1

set -x
rm -f *.asc
for f in *; do
    gpg --detach-sign --armor "$f"
done
