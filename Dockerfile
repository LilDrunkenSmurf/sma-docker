FROM ubuntu:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="SMA-Manual version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="LilDrunkenSmurf"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"
ENV SMA_PATH /usr/local/sma
ENV SMA_UPDATE false
ENV SMA_FFMPEG_URL https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz

# get python3 and git, and install python libraries
RUN \
  apt-get update && \
  apt-get install -y \
    git \
    wget \
    python3 \
    python3-pip && \
# make directory
  mkdir ${SMA_PATH} && \
# download repo
  git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git ${SMA_PATH} && \
# install pip, venv, and set up a virtual self contained python environment
  python3 -m pip install --user --upgrade pip && \
  python3 -m pip install --user virtualenv && \
  python3 -m virtualenv ${SMA_PATH}/venv && \
  ${SMA_PATH}/venv/bin/pip install -r ${SMA_PATH}/setup/requirements.txt && \
# ffmpeg
  wget ${SMA_FFMPEG_URL} -O /tmp/ffmpeg.tar.xz && \
  tar -xJf /tmp/ffmpeg.tar.xz -C /usr/local/bin --strip-components 1 && \
  chgrp users /usr/local/bin/ffmpeg && \
  chgrp users /usr/local/bin/ffprobe && \
  chmod g+x /usr/local/bin/ffmpeg && \
  chmod g+x /usr/local/bin/ffprobe && \
# cleanup
  apt-get purge --auto-remove -y && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# ports and volumes
VOLUME /config
VOLUME /usr/local/sma/config

# update.py sets FFMPEG/FFPROBE paths, updates API key and Sonarr/Radarr settings in autoProcess.ini
COPY extras/ ${SMA_PATH}/
COPY root/ /

# run command script
ENTRYPOINT [ "${SMA_PATH}/manual.sh" ]