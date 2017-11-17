FROM mindegy/codecompass

# TODO: Should be used with non root user
ENV USERS_HOME             /root

# The following environment variables are used by the scripts that performs
# the CodeCompass related tasks. They can be overwritten by the descendant
# image(s)
# Exact documentation can be found on the beginning of the parse_project.sh.
# See the bin directory.

# Database connection arguments. They could be overwritten in the descendant
# image.
ENV PROJECT_NAME           codecompass
ENV DATABASE_HOST          localhost
ENV DATABASE_PORT          5432
ENV DATABASE_USER_NAME     postgres
ENV DATABASE_USER_PASSWORD postgres

# Directory where the particular project perfoms the build.
ENV PROJECT_WORKSPACE_DIR  ${USERS_HOME}/ws

# Directory where the project specific configuration files can be stored.
ENV CONFIG_DIR             ${USERS_HOME}/config

# Directory that must be shared between this parser and CC webserver
# For example you can use Docker volumes.
ENV CC_SHARED_WORKSPACE_DIR   /data

ENV SCRIPT_DIR ${USERS_HOME}/bin

WORKDIR    ${USERS_HOME}

# Copy all config file to the config directory.
COPY ./config ${CONFIG_DIR}

RUN                                                                           \
    cp ${CONFIG_DIR}/sources.list /etc/apt                                 && \
    apt-get update                                                         && \
    apt-get install --yes bear ctags cmake

# Copy all scripts to the script directory.
COPY ./bin ${SCRIPT_DIR}

# Install CC parser helper scripts
RUN chmod u+x \
    ${SCRIPT_DIR}/parse_project.sh \
    ${SCRIPT_DIR}/build_project.sh

# Perform logging/parsing tasks. The task specialization should be placed in
# descendant image. Create ${SCRIPT_DIR}/project_specific.sh in the
# ${SCRIPT_DIR}.
CMD ${SCRIPT_DIR}/parse_project.sh

