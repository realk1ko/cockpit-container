ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG COCKPIT_VERSION

LABEL org.opencontainers.image.title Cockpit
LABEL org.opencontainers.image.description The easy-to-use, integrated, glanceable, and open web-based interface for your servers
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.url https://github.com/realk1ko/cockpit-docker
LABEL maintainer realk1ko <32820057+realk1ko@users.noreply.github.com>

RUN dnf install -y cockpit-ws-${COCKPIT_VERSION} cockpit-bridge-${COCKPIT_VERSION} && \
    dnf clean all && \
    echo 'NAME=default\nID=default' > /etc/os-release

ADD ./container /container

CMD ["/container/run.sh"]
