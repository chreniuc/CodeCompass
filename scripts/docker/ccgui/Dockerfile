FROM mindegy/codecompass

# TODO Prepare for configurable user.
WORKDIR /root

COPY start_webserver.sh .
RUN chmod u+x ./start_webserver.sh

CMD ./start_webserver.sh \
        ${DATABASE_HOST:-localhost} \
        ${DATABASE_PORT:-5432} \
        ${DATABASE_USER_NAME:-postgres} \
        ${DATABASE_USER_PASSWORD:-postgres} \
        ${WEBSERVER_PORT:-6251} \
        ${SHARED_WORKSPACE_DIR:-/data}
