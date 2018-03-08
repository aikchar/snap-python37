#!/bin/sh
set -e
rm -rf /snap/core/current/
snap install --classic --dangerous python37_"${PYTHON37_VERSION}"_amd64.snap
python3.7 --version
snap remove python37
