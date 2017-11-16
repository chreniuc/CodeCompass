#!/usr/bin/env bash

THRIFT_INSTALL_DIR="/opt/thrift"
CLANG_INSTALL_DIR="/opt/llvm"
ODB_INSTALL_DIR="/opt/odb"
CC_INSTALL_DIR="/opt/CodeCompass"

export CMAKE_PREFIX_PATH="${THRIFT_INSTALL_DIR}:${CMAKE_PREFIX_PATH}"
export CMAKE_PREFIX_PATH="${CLANG_INSTALL_DIR}/share/llvm/cmake:${CMAKE_PREFIX_PATH}"
export CMAKE_PREFIX_PATH="${ODB_INSTALL_DIR}:${CMAKE_PREFIX_PATH}"

export PATH="${THRIFT_INSTALL_DIR}/bin:${PATH}"
export PATH="${ODB_INSTALL_DIR}/bin:${PATH}"

CODE_COMPASS_BUILD_DIR="/tmp/codecompass"
mkdir -p "${CODE_COMPASS_BUILD_DIR}"
pushd "${CODE_COMPASS_BUILD_DIR}"
git clone https://github.com/Ericsson/CodeCompass.git
mkdir build
cd build
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
cmake ../CodeCompass \
  "-DCMAKE_INSTALL_PREFIX=${CC_INSTALL_DIR}" \
  "-DDATABASE=pgsql" \
  "-DCMAKE_BUILD_TYPE=Release"
make -j4
make install
popd

