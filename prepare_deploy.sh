#!/bin/bash
#
# 
# Description : Prepare deploy packages for avor install application. 
# Author : vassilux
# Last modified : 2014-09-19 14:37:47 
#

set -e

VER_MAJOR="1"
VER_MINOR="0"
VER_PATCH="0"

APP_NAME="avor_install"

DEPLOY_DIR="${APP_NAME}_${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}"
DEPLOY_FILE_NAME="${APP_NAME}_${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}.tar.gz"

if [ -d "$DEPLOY_DIR" ]; then
    rm -rf  "$DEPLOY_DIR"
fi
#
if [ -f "$DEPLOY_FILE_NAME" ]; then
    rm -rf  "$DEPLOY_FILE_NAME"
fi
#
#
mkdir "$DEPLOY_DIR"
mkdir "$DEPLOY_DIR/asterisk"
cp -aR asterisk/* "$DEPLOY_DIR/asterisk"
mkdir "$DEPLOY_DIR/sql"
cp -aR sql/* "$DEPLOY_DIR/sql"
#
cp install.sh "$DEPLOY_DIR"
tar czf "${DEPLOY_FILE_NAME}" "${DEPLOY_DIR}"

if [ ! -f "$DEPLOY_FILE_NAME" ]; then
    echo "Deploy build failed."
    exit 1
fi


rm -rf "$DEPLOY_DIR"
echo "Deploy build complete."
