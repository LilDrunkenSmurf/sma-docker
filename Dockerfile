FROM jrottenberg/ffmpeg:snapshot-ubuntu
LABEL maintainer="LilDrunkenSmurf"

# set environment variables
ENV SMA_PATH /usr/local/sma
ENV MEDIA_PATH /data

# get python3 and git, and install python libraries
RUN \
  apt-get update && \
  apt-get install -y \
    git \
    python3 \
    python3-pip && \
# make directory
  mkdir ${SMA_PATH} && \
# download repo
  git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git ${SMA_PATH} && \
  cp ${SMA_PATH}/setup/autoProcess.ini.sample ${SMA_PATH}/config/autoProcess.ini && \
# install pip
  python3 -m pip install --upgrade pip && \
  pip install -r ${SMA_PATH}/setup/requirements.txt && \
# cleanup
  apt-get purge --auto-remove -y && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# ports and volumes
VOLUME /config
VOLUME /data
VOLUME /usr/local/sma/config

# Build a shell script because the ENTRYPOINT command doesn't like using ENV
RUN echo "#!/bin/bash \n python3 $SMA_PATH/manual.py -i $MEDIA_PATH -a" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# run command script
CMD [ "./entrypoint.sh" ]
