ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG COCKPIT_VERSION

LABEL org.opencontainers.image.title Cockpit
LABEL org.opencontainers.image.description The easy-to-use, integrated, glanceable, and open web-based interface for your servers
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.url https://github.com/realk1ko/cockpit-container
LABEL maintainer realk1ko <32820057+realk1ko@users.noreply.github.com>

ADD ./container /

ADD ./LICENSE /

RUN set -euo pipefail && \
    dnf install -y cockpit-ws-${COCKPIT_VERSION} cockpit-bridge-${COCKPIT_VERSION} python3 openssh-clients && \
    dnf clean all && \
    echo "NAME=default\nID=default" > /etc/os-release && \
    chmod 755 /usr/local/bin/*

ENV COCKPIT_SSH_KEY_PATH /etc/cockpit/identity

CMD ["/usr/local/bin/start"]
