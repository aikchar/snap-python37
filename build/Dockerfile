FROM codeghar/snapcraft:latest

COPY . /build_root

WORKDIR /build_root

ARG PYTHON37_VERSION=3.7.0b2

ENV PYTHON37_VERSION=${PYTHON37_VERSION}

RUN apt update \
    && snapcraft snap
