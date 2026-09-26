FROM debian:bookworm-slim@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251

ARG CALIBRE_VERSION=9.15.0
ARG CALIBRE_SHA256=3f5301c0aa51e5fb2d5f6dcd04024ba4e86501ab328ce5d9d6760efccb887990

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       xz-utils \
       fontconfig \
       libfreetype6 \
       libglib2.0-0 \
       libx11-6 \
       libxext6 \
       libxrender1 \
       libxcb1 \
       libdbus-1-3 \
       libgl1 \
       tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN curl --fail --location --silent --show-error \
      "https://download.calibre-ebook.com/${CALIBRE_VERSION}/calibre-${CALIBRE_VERSION}-x86_64.txz" \
      --output /tmp/calibre.txz \
    && echo "${CALIBRE_SHA256}  /tmp/calibre.txz" | sha256sum -c - \
    && mkdir -p /opt/calibre \
    && tar -xJf /tmp/calibre.txz -C /opt/calibre \
    && rm /tmp/calibre.txz

RUN useradd --create-home --uid 1000 --shell /usr/sbin/nologin converter

ENV PATH="/opt/calibre:${PATH}" \
    HOME="/home/converter"

USER converter
WORKDIR /work

ENTRYPOINT ["/opt/calibre/ebook-convert"]
