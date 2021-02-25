FROM debian:10-slim

WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget expect

RUN wget -O envsubst https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64
RUN chmod +x envsubst && mv envsubst /usr/local/bin

RUN wget -O wowza-installer.run https://www.wowza.com/downloads/WowzaStreamingEngine-4-8-10/WowzaStreamingEngine-4.8.10-linux-x64-installer.run
COPY install.exp install.exp
COPY entrypoint.sh entrypoint.sh

RUN chmod +x install.exp entrypoint.sh wowza-installer.run
RUN expect install.exp
RUN rm /usr/local/WowzaStreamingEngine/conf/Server.license

# Backups (for volumes)
RUN mkdir wowza-backup && cp -r /usr/local/WowzaStreamingEngine/conf /root/wowza-backup/conf

VOLUME /usr/local/WowzaStreamingEngine/conf
VOLUME /usr/local/WowzaStreamingEngine/applications
VOLUME /usr/local/WowzaStreamingEngine/content
VOLUME /usr/local/WowzaStreamingEngine/logs

ENTRYPOINT /root/entrypoint.sh
