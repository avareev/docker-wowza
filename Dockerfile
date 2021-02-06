FROM debian:10-slim

WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget expect

RUN wget -O envsubst https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64
RUN chmod +x envsubst && mv envsubst /usr/local/bin

RUN wget -O wowza-installer.run https://www.wowza.com/downloads/WowzaStreamingEngine-4-8-8-01/WowzaStreamingEngine-4.8.8.01-linux-x64-installer.run
COPY install.exp install.exp
COPY entrypoint.sh entrypoint.sh

RUN chmod +x install.exp entrypoint.sh wowza-installer.run
RUN expect install.exp

WORKDIR /usr/local/WowzaStreamingEngine/updates
COPY updater.sh updater.sh
RUN ls -la
RUN chmod +x updater.sh && sh -c "./updater.sh"

WORKDIR /usr/local/WowzaStreamingEngine
RUN rm -rf updates/* && rm conf/Server.license

# Backups (for volumes)
RUN mkdir /root/wowza-backup && cp -r conf /root/wowza-backup/conf

VOLUME /usr/local/WowzaStreamingEngine/conf
VOLUME /usr/local/WowzaStreamingEngine/applications
VOLUME /usr/local/WowzaStreamingEngine/content
VOLUME /usr/local/WowzaStreamingEngine/logs

ENTRYPOINT /root/entrypoint.sh
