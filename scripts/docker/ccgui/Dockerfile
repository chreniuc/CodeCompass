FROM mindegy/codecompass

# TODO Prepare for configurable user.
WORKDIR /root

COPY start_webserver.sh .
RUN chmod u+x ./start_webserver.sh

EXPOSE ${WEBSERVER_PORT}

CMD ./start_webserver.sh \
        ${DATABASE_HOST} \
        ${DATABASE_PORT} \
        ${DATABASE_USER_NAME} \
        ${DATABASE_USER_PASSWORD} \
        ${WEBSERVER_PORT} \
        ${SHARED_WORKSPACE_DIR}
