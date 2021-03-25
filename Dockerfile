FROM debian:10-slim

WORKDIR /root

RUN apt-get update \
    && apt-get install -y supervisor wget expect

COPY supervisor /etc/supervisor

RUN wget -O envsubst https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64
RUN chmod +x envsubst && mv envsubst /usr/local/bin

RUN wget -O wowza-installer.run https://www.wowza.com/downloads/WowzaStreamingEngine-4-8-11+5/WowzaStreamingEngine-4.8.11+5-linux-x64-installer.run
COPY install.exp install.exp
COPY exitzero.sh exitzero.sh

RUN chmod +x install.exp wowza-installer.run exitzero.sh
RUN expect install.exp
RUN rm /usr/local/WowzaStreamingEngine/conf/Server.license

# Backups (for volumes)
RUN mkdir wowza-backup && cp -r /usr/local/WowzaStreamingEngine/conf /root/wowza-backup/conf

VOLUME /usr/local/WowzaStreamingEngine/conf
VOLUME /usr/local/WowzaStreamingEngine/applications
VOLUME /usr/local/WowzaStreamingEngine/content
VOLUME /usr/local/WowzaStreamingEngine/logs

COPY entrypoint.sh entrypoint.sh
COPY exitzero.sh exitzero.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
