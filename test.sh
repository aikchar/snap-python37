#!/bin/sh
set -e
cd /root/python37
snap install --classic --dangerous python37_3.7.0a3+0_amd64.snap
python37 --version
snap remove python37
cd -
