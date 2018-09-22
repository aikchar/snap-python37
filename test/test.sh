#!/bin/sh
set -e
snap install --classic --dangerous "${TEST_CONTAINER_ARTIFACTS_DIR}/${SNAP_NAME}_${PYTHON37_VERSION}_amd64.snap"
echo "Python version installed with snap is: $(${SNAP_NAME}.python37 --version)"
