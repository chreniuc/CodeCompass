#!/usr/bin/env bash

scriptdir=$(readlink -ev "$(dirname "$(which "$0")")")

${scriptdir}/install_dbaccess.sh &
${scriptdir}/install_thrift.sh &
${scriptdir}/install_llvm.sh &
${scriptdir}/install_gtest.sh &
wait
${scriptdir}/install_codecompass.sh

