# syntax=docker/dockerfile:1
# Minimal headless ebook-convert image (Calibre CLI only — geen GUI/VNC/server).
#
# Bron: officiële Calibre binary-bundle van download.calibre-ebook.com (calibre's
# eigen infrastructuur), checksum-verificatie in de build. Base en bundle zijn
# beide gepind; bij een nieuwe Calibre-versie: ARG's aanpassen + nieuw sha256.

FROM debian:bookworm-slim@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251

ARG CALIBRE_VERSION=9.15.0
ARG CALIBRE_TXZ_SHA256=3f5301c0aa51e5fb2d5f6dcd04024ba4e86501ab328ce5d9d6760efccb887990

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates wget xz-utils tzdata \
      libglib2.0-0 libfontconfig1 libfreetype6 \
      libx11-6 libxrender1 libxext6 libgl1 libdbus-1-3 \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /opt/calibre /tmp/calibre-dl \
 && wget -q -O /tmp/calibre-dl/calibre.txz \
      "https://download.calibre-ebook.com/${CALIBRE_VERSION}/calibre-${CALIBRE_VERSION}-x86_64.txz" \
 && echo "${CALIBRE_TXZ_SHA256}  /tmp/calibre-dl/calibre.txz" | sha256sum -c - \
 && tar -xJf /tmp/calibre-dl/calibre.txz -C /opt/calibre \
 && rm -rf /tmp/calibre-dl \
 && useradd -u 1000 -M -d /tmp app \
 && chown -R root:root /opt/calibre \
 && chmod -R a-w,go-w /opt/calibre \
 && chmod 1777 /tmp

ENV PATH="/opt/calibre:$PATH" \
    HOME="/tmp" \
    QT_QPA_PLATFORM=offscreen \
    TZ=UTC

# Non-root (uid 1000). Bij gebruik met een root-owned host-mount voor output:
# geef de mount world-writable mee (bv. chmod 1777) of draai met --user.
USER app

WORKDIR /tmp
ENTRYPOINT ["/opt/calibre/ebook-convert"]
