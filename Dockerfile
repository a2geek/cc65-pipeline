FROM alpine:latest

LABEL description="This is a cc65 Docker container intended to be used for build pipelines."

ENV VERSION="V2.16"

RUN apk add --no-cache build-base && \
    wget -P /tmp https://github.com/cc65/cc65/archive/${VERSION}.tar.gz && \
    cd /tmp && \
    tar xzf *.tar.gz && \
    cd cc65* && \
    env prefix=/usr/local make && \
    env prefix=/usr/local make install && \
    cd - && \
    rm -rf *.tar.gz cc65* && \
    apk del --no-cache build-base && \
    apk add --no-cache make
