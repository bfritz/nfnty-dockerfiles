FROM nfnty/arch-mini:latest

MAINTAINER "nfnty <docker@nfnty.se>"

ENV UGID="220000" UGNAME="dovecot" PRIMPATH="/dovecot"
ENV UGID2="220001" UGNAME2="dovenull"

RUN groupadd --gid "${UGID}" "${UGNAME}" && \
    useradd --uid "${UGID}" --gid "${UGID}" --shell /usr/bin/false "${UGNAME}" && \
    groupadd --gid "${UGID2}" "${UGNAME2}" && \
    useradd --uid "${UGID2}" --gid "${UGID2}" --shell /usr/bin/false "${UGNAME2}"

RUN install --directory --owner=root --group="${UGNAME}" --mode=750 \
        "${PRIMPATH}/"{,config,crypto,lib} && \
        ln --symbolic "${PRIMPATH}/lib" /var/lib/dovecot
VOLUME ["${PRIMPATH}/config", "${PRIMPATH}/crypto", "${PRIMPATH}/lib"]

RUN install --directory --owner="${UGNAME}" --group="${UGNAME}" --mode=700 \
        "${PRIMPATH}/"{run,maildir} && \
    ln --symbolic "${PRIMPATH}/run" /run/dovecot
VOLUME ["${PRIMPATH}/run", "${PRIMPATH}/maildir"]

ENV DOVECOT_VERSION="2.2.18-1"
RUN pacman --sync --noconfirm --refresh --sysupgrade && \
    pacman --sync --noconfirm "dovecot=${DOVECOT_VERSION}" && \
    find /var/cache/pacman/pkg -mindepth 1 -delete

USER root
EXPOSE 24 143
ENTRYPOINT ["/usr/bin/dovecot", "-F", "-c", "/dovecot/config/dovecot.conf"]
