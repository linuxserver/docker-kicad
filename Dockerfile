FROM ghcr.io/linuxserver/baseimage-selkies:alpine322

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KICAD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=KiCad

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/kicad-logo.png && \
  echo "**** install packages ****" && \
  if [ -z ${KICAD_VERSION+x} ]; then \
    KICAD_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.22/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:kicad$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    kicad==${KICAD_VERSION} \
    kicad-library \
    kicad-library-3d \
    mousepad \
    py3-wxpython && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
