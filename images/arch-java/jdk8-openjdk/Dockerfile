FROM nfnty/arch-mini:latest

MAINTAINER "nfnty <docker@nfnty.se>"

ENV PATH="${PATH}:/usr/lib/jvm/default/bin"

ENV JAVA_VERSION="8.u45-1"
RUN pacman --sync --noconfirm --refresh --sysupgrade && \
    pacman --sync --noconfirm "jdk8-openjdk=${JAVA_VERSION}" && \
    find /var/cache/pacman/pkg -mindepth 1 -delete
