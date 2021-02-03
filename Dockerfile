FROM debian:10-slim

WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget expect

RUN wget -O wowza-installer.run https://www.wowza.com/downloads/WowzaStreamingEngine-4-8-8-01/WowzaStreamingEngine-4.8.8.01-linux-x64-installer.run

COPY install.exp install.exp
COPY entrypoint.sh entrypoint.sh

RUN chmod +x install.exp entrypoint.sh wowza-installer.run

RUN expect install.exp

VOLUME /usr/local/WowzaStreamingEngine/conf
VOLUME /usr/local/WowzaStreamingEngine/applications
VOLUME /usr/local/WowzaStreamingEngine/content
VOLUME /usr/local/WowzaStreamingEngine/logs

ENTRYPOINT /root/entrypoint.sh
