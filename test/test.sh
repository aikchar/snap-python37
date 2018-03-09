#!/bin/sh
set -e
snap install --classic --dangerous "python37_${PYTHON37_VERSION}_amd64.snap"
echo "Python version installed with snap is: $(python37 --version)"
