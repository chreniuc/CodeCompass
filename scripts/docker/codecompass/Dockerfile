FROM ubuntu:16.04 AS xenial-base

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk


FROM xenial-base AS code-compass-installer

# The "libsqlite3-dev" is a workaround because we want to use postgres only.
RUN apt-get install -y \
    apt-utils \
    cmake \
    cpp \
    ctags \
    curl \
    gcc-5-plugin-dev \
    git \
    libboost-all-dev \
    libcutl-dev \
    libgit2-dev \
    libgraphviz-dev \
    libgtest-dev \
    libmagic-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    npm \
    wget \
    xz-utils

WORKDIR /root
COPY ./bin ./bin
RUN chmod u+x \
    ./bin/install_all.sh \
    ./bin/install_dbaccess.sh \
    ./bin/install_llvm.sh \
    ./bin/install_thrift.sh \
    ./bin/install_gtest.sh \
    ./bin/install_codecompass.sh
RUN ./bin/install_all.sh


FROM xenial-base AS code-compass

RUN apt-get install -y \
    libboost-filesystem1.58.0 \
    libboost-log1.58.0 \
    libboost-program-options1.58.0 \
    libboost-thread1.58.0 \
    libgit2-24 \
    libgvc6 \
    libpq5

COPY --from=code-compass-installer /opt /opt

CMD ["/bin/bash"]
