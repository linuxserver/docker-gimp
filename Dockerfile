FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine320

# set version label
ARG BUILD_DATE
ARG VERSION
ARG GIMP_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=GIMP

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/gimp-logo.png && \
  echo "**** install packages ****" && \
  if [ -z ${GIMP_VERSION+x} ]; then \
    GIMP_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.20/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:gimp$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    gimp==${GIMP_VERSION} && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
