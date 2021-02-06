#! /bin/bash

wget -O update-489.tar.gz https://files.avar.pro/s/nrySSPLw3JPCcGx/download
tar xvzf update-489.tar.gz

cd ./4-8-9/linux/
chmod +x *

expect ./update.exp