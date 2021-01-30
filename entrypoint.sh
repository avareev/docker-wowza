#!/bin/bash

/usr/local/WowzaStreamingEngine/manager/bin/startmgr.sh > mngr.log 2>&1 &
/usr/local/WowzaStreamingEngine/bin/startup.sh
