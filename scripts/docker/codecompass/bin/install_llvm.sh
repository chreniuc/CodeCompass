#!/usr/bin/env bash

LLVM_INSTALL_DIR="/opt/llvm"
LLVM_BUILD_DIR="/tmp/llvm"
LLVM_MIRROR="http://releases.llvm.org"
LLVM_VERSION="3.8.0"

mkdir -p "${LLVM_BUILD_DIR}"
pushd "${LLVM_BUILD_DIR}"

LLVM_SRC_ARCHIVE_NAME="llvm-${LLVM_VERSION}.src.tar.xz"
LLVM_CFE_ARCHIVE_NAME="cfe-${LLVM_VERSION}.src.tar.xz"
LLVM_RT_ARCHIVE_NAME="compiler-rt-${LLVM_VERSION}.src.tar.xz"

wget "${LLVM_MIRROR}/${LLVM_VERSION}/${LLVM_SRC_ARCHIVE_NAME}"
wget "${LLVM_MIRROR}/${LLVM_VERSION}/${LLVM_CFE_ARCHIVE_NAME}"
wget "${LLVM_MIRROR}/${LLVM_VERSION}/${LLVM_RT_ARCHIVE_NAME}"

mkdir -p llvm
tar -xf "${LLVM_SRC_ARCHIVE_NAME}" -C "llvm" --strip-components=1
mkdir -p "llvm/tools/clang"
tar -xf "${LLVM_CFE_ARCHIVE_NAME}" -C "llvm/tools/clang" --strip-components=1
mkdir -p "llvm/projects/compiler-rt"
tar -xf "compiler-rt-${LLVM_VERSION}.src.tar.xz" -C "llvm/projects/compiler-rt" --strip-components=1

mkdir build
cd build
export REQUIRES_RTTI=1
cmake -G "Unix Makefiles" "-DLLVM_ENABLE_RTTI=ON" "-DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL_DIR}" "../llvm"
make -j 4 install
popd

