FROM nfnty/arch-mini:latest

MAINTAINER "nfnty <docker@nfnty.se>"

ENV NODEJS_VERSION="0.12.4-1"
RUN pacman --sync --noconfirm --refresh --sysupgrade && \
    pacman --sync --noconfirm "nodejs=${NODEJS_VERSION}" && \
    find /var/cache/pacman/pkg -mindepth 1 -delete
