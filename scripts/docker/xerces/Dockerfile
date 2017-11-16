FROM ccparser

ARG project_name
ARG database_host
ARG database_port
ARG database_user_name
ARG database_users_password
ARG project_workspace_dir
ARG shared_workspace_dir

# TODO: Should be used with non root user
ENV USERS_HOME             /root

# Database connection arguments
ENV PROJECT_NAME           ${project_name:-codecompass}
ENV DATABASE_HOST          ${database_host:-localhost}
ENV DATABASE_PORT          ${database_port:-5432}
ENV DATABASE_USER_NAME     ${database_user_name:-postgres}
ENV DATABASE_USER_PASSWORD ${database_users_password:-postgres}

# Directory where the particular project perfoms the build
ENV PROJECT_WORKSPACE_DIR  ${project_workspace_dir:-${PROJECT_WORKSPACE_DIR}}

# Directory that must be shared between this parser and CC webserver
ENV CC_SHARED_WORKSPACE_DIR   ${shared_workspace_dir:-/data}

RUN apt-get install --yes                                                     \
    autoconf libcurl3 g++ make cmake

WORKDIR ${USERS_HOME}

# Copy all scripts to the script directory, including project specific things
COPY ./bin ${USERS_HOME}/bin

RUN                                                                           \
    mkdir -p /mnt/ws                                                       && \
    chmod u+x ${SCRIPT_DIR}/filterbuildcmds.py
