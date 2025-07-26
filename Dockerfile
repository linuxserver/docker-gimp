FROM ghcr.io/linuxserver/baseimage-selkies:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG KRITA_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=GIMP

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/gimp-logo.png && \
  echo "**** install packages ****" && \
  DOWNLOAD_PATH=$(curl -sL https://download.gimp.org/gimp/GIMP-Stable-x86_64.AppImage.zsync \
    | awk '/URL:/ {print $2}') && \
  DOWNLOAD_PATH=$(echo $DOWNLOAD_PATH | sed 's/v3.1/v3.0/g') && \
  curl -o \
    /tmp/gimp.app -L \
    "https://download.gimp.org/gimp/${DOWNLOAD_PATH}" && \
  cd /tmp && \
  chmod +x gimp.app && \
  ./gimp.app --appimage-extract && \
  mv \
    squashfs-root \
    /opt/gimp && \
  ln -s \
    /opt/gimp/AppRun \
    /usr/bin/gimp && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
