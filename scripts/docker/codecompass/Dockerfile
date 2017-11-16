FROM ubuntu:16.04 AS xenial-base

RUN apt-get update && \
    apt-get install --yes openjdk-8-jdk

FROM xenial-base AS code-compass-installer

# The "libsqlite3-dev" is a workaround because we want to use postgres only.
RUN apt-get install --yes \
    git cmake apt-utils xz-utils libboost-all-dev libssl-dev            \
    libgraphviz-dev libgit2-dev ctags wget curl npm libpq-dev           \
    gcc-5-plugin-dev libcutl-dev libmagic-dev libgtest-dev              \
    libsqlite3-dev cpp                                               && \
    apt-get upgrade --yes

WORKDIR /root
COPY ./bin ./bin
RUN \
    chmod u+x ./bin/install_all.sh                                   && \
    chmod u+x ./bin/install_dbaccess.sh                              && \
    chmod u+x ./bin/install_llvm.sh                                  && \
    chmod u+x ./bin/install_thrift.sh                                && \
    chmod u+x ./bin/install_gtest.sh                                 && \
    chmod u+x ./bin/install_codecompass.sh
RUN ./bin/install_all.sh

FROM xenial-base AS code-compass

RUN apt-get install --yes \
    libboost-thread1.58.0 libboost-filesystem1.58.0 libgvc6         \
    libboost-program-options1.58.0 libboost-log1.58.0 libpq5        \
    libgit2-24

COPY --from=code-compass-installer /opt /opt

CMD ["/bin/bash"]

