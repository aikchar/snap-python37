#!/bin/sh
set -e
pwd
ls -lA
# Change directory because ``snapcraft`` expects snapcraft.yaml in pwd
(
    cd ./snap-python37-src/build
    . ./build.sh
)
ls -lA
ls -lA snap/
cp ./snap-python37-src/build/*.snap snap-python37-artifacts/
