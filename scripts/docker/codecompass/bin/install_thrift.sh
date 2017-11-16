#!/usr/bin/env bash

THRIFT_VERSION="0.10.0"
THRIFT_ARCHIVE_NAME="thrift-${THRIFT_VERSION}.tar.gz"
THRIFT_BUILD_DIR="/tmp/thrift"
THRIFT_SRC_DIR="${THRIFT_BUILD_DIR}/thrift"
THRIFT_INSTALL_DIR="/opt/thrift"

mkdir -p "${THRIFT_SRC_DIR}"
wget "http://xenia.sote.hu/ftp/mirrors/www.apache.org/thrift/${THRIFT_VERSION}/${THRIFT_ARCHIVE_NAME}" -O "${THRIFT_BUILD_DIR}/${THRIFT_ARCHIVE_NAME}"
tar -xzf "${THRIFT_BUILD_DIR}/${THRIFT_ARCHIVE_NAME}" -C "${THRIFT_SRC_DIR}" --strip-components=1
pushd "${THRIFT_SRC_DIR}"
./configure "--prefix=${THRIFT_INSTALL_DIR}" --without-nodejs
make install
popd

