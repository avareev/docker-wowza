#!/bin/bash
if ! [[ "$(ls -A /usr/local/WowzaStreamingEngine/conf)" ]]
then
    echo "Wowza Streaming Engine configuration not found. Restoring."
    cp -r /root/wowza-backup/conf/* /usr/local/WowzaStreamingEngine/conf
fi

if [ -z $WSE_LIC ]
then
    echo "Please set WSE_LIC"
    exit 1
else
    echo $WSE_LIC > /usr/local/WowzaStreamingEngine/conf/Server.license
fi

if [ -z $DIRECT_START ]
then
    exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
else
    /usr/local/WowzaStreamingEngine/manager/bin/startmgr.sh > mngr.log 2>&1 &
    /usr/local/WowzaStreamingEngine/bin/startup.sh
fi
