#!/bin/sh
set -e
# Change directory because ``snapcraft`` expects snapcraft.yaml in pwd
(
    cd ./snap-python37-src/build
    . ./build.sh
)
cp ./snap-python37-src/build/*.snap snap-python37-artifacts/
