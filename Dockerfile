FROM docker.io/library/fedora:latest

RUN dnf install -y cockpit-ws cockpit-bridge && \
    dnf clean all && \
    printf 'NAME=default\nID=default\n' > /etc/os-release

ADD ./container /container

CMD ["/container/run.sh"]
