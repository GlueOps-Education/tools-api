FROM jetpackio/devbox:0.18.5@sha256:1aa6b2c3272317bbdc7f6255ab745315ff7efc28af2c2745970470602d9e87be

# Installing your devbox project
WORKDIR /code
USER root:root

RUN mkdir -p /code && chown ${DEVBOX_USER}:${DEVBOX_USER} /code
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} Pipfile Pipfile
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} Pipfile.lock Pipfile.lock

# Accept build arguments for versioning
ARG VERSION=unknown
ARG COMMIT_SHA=unknown
ARG BUILD_TIMESTAMP=unknown

ENV VERSION=${VERSION}
ENV COMMIT_SHA=${COMMIT_SHA}
ENV BUILD_TIMESTAMP=${BUILD_TIMESTAMP}

RUN devbox run -- echo "Installed Packages."
RUN devbox run pipenv install

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} app/ /code/app

CMD [ "devbox", "run", "k8s"]