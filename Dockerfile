FROM alpine:latest

LABEL description="This is a cc65 Docker container intended to be used for build pipelines."

ENV BUILD_DIR="/tmp" \
    CC65_VERSION="V2.19" \
    NULIB2_VERSION="v3.1.0" \
    AC_VERSION="1.7.0"

COPY bin /usr/local/bin

RUN apk add --no-cache build-base binutils && \
    echo "Building CC65 ${CC65_VERSION}" && \
    cd ${BUILD_DIR} && \
    wget https://github.com/cc65/cc65/archive/${CC65_VERSION}.tar.gz && \
    tar xzf ${CC65_VERSION}.tar.gz && \
    cd cc65* && \
    env PREFIX=/usr/local make && \
    env PREFIX=/usr/local make install && \
    echo "Building NuLib2 ${NULIB2_VERSION}" && \
    cd ${BUILD_DIR} && \
    wget https://github.com/fadden/nulib2/archive/${NULIB2_VERSION}.tar.gz && \
    tar xzf ${NULIB2_VERSION}.tar.gz && \
    cd nulib2* && \
    cd nufxlib && \
    ./configure && \
    make && \
    make install && \
    cd ../nulib2 && \
    ./configure && \
    make && \
    make install && \
    mkdir -p /usr/local/share/java && \
    echo "Adding AppleCommander 'ac'" && \
    wget https://github.com/AppleCommander/AppleCommander/releases/download/${AC_VERSION}/AppleCommander-ac-${AC_VERSION}.jar && \
    mv AppleCommander-ac-${AC_VERSION}.jar /usr/local/share/java/AppleCommander-ac.jar && \
    echo "Adding AppleCommander 'acx'" && \
    wget https://github.com/AppleCommander/AppleCommander/releases/download/${AC_VERSION}/AppleCommander-acx-${AC_VERSION}.jar && \
    mv AppleCommander-acx-${AC_VERSION}.jar /usr/local/share/java/AppleCommander-acx.jar && \
    echo "Cleaning up" && \
    cd ${BUILD_DIR} && \
    rm -rf * && \
    apk del --no-cache build-base && \
    echo "Adding other required build-tools exclusive of other C compilers!" && \
    apk add --no-cache make openjdk11-jre && \
    chmod +x /usr/local/bin/*
