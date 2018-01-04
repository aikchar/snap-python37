#!/bin/sh
set -e
cd /root/python37
snap install --devmode python37_3.7_amd64.snap
python37 --version
cd -
