FROM nfnty/arch-mini:latest

MAINTAINER "nfnty <docker@nfnty.se>"

ENV UGID="120000" UGNAME="kibana" PRIMPATH="/kibana"

RUN groupadd --gid "${UGID}" "${UGNAME}" && \
    useradd --uid "${UGID}" --gid "${UGID}" --shell /usr/bin/false "${UGNAME}"

RUN install --directory --owner=root --group="${UGNAME}" --mode=750 \
        "${PRIMPATH}/"{,bin,config,crypto}
ADD config/ ${PRIMPATH}/config/
RUN chown --recursive "root:${UGNAME}" "${PRIMPATH}/config" && \
    chmod --recursive 'u=rwX,g=rX,o=' "${PRIMPATH}/config"

RUN pacman --sync --noconfirm --refresh --sysupgrade && \
    pacman --sync --noconfirm util-linux && \
    find /var/cache/pacman/pkg -mindepth 1 -delete

ENV KIBANA_VERSION="4.0.1"
RUN curl "https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x64.tar.gz" | \
        tar --extract --gzip --strip-components=1 --file=- --directory="${PRIMPATH}/bin" && \
    chown --recursive "root:${UGNAME}" "${PRIMPATH}/bin" && \
    chmod --recursive 'u=rwX,g=rX,o=' "${PRIMPATH}/bin"  && \
    rm --recursive "${PRIMPATH}/bin/config" && \
    ln --symbolic "${PRIMPATH}/config" "${PRIMPATH}/bin/config"

USER ${UGNAME}
EXPOSE 5601
ENTRYPOINT ["/kibana/bin/bin/kibana"]
