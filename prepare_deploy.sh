#!/bin/bash
#
# 
# Description : Prepare deploy revor package. 
# Author : vassilux
# Last modified : 2014-09-19 14:53:54  
#

set -e

VER_MAJOR="1"
VER_MINOR="0"
VER_PATCH="0"

DEPLOY_APP="avoir_install"


DEPLOY_APP_VER="${DEPLOY_APP}_${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}"
DEPLOY_DIR="${DEPLOY_APP_VER}"
#
if [ -d "${DEPLOY_DIR}" ]; then
	rm -rf ${DEPLOY_DIR}
fi

if [ -f "${DEPLOY_APP}.tar.gz" ]; then
	rm -rf "${DEPLOY_APP}.tar.gz"
fi

mkdir "${DEPLOY_DIR}"

#
mv "${DEPLOY_APP}.tar.gz" "$DEPLOY_DIR"
cd "${DEPLOY_DIR}"
tar xvzf avoir_install.tar.gz
rm -rf "${DEPLOY_APP}.tar.gz"
cd ..
tar cvzf "${DEPLOY_APP_VER}.tar.gz" ${DEPLOY_APP_VER}


rm -rf "${DEPLOY_APP_VER}"

echo "Deploy finished."
