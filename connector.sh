#!/usr/bin/bash

pid=`ps -ef | grep -i "local.connector" | grep -v "grep" | awk '{print $2}'`
if [ -n "$pid" ]; then
    echo "kill running /local_connector $pid"
    kill -9 "$pid"
fi
args=$*
rm -rf /local_connector

mkdir -p /local_connector

wget https://raw.githubusercontent.com/tax0x7e7/tax_miner_proxy/master/本地加密端/linux/local.connector -O /local_connector/local.connector

chmod u+x /local_connector/local.connector 

/local_connector/local.connector $args -install
/local_connector/local.connector $args -start

