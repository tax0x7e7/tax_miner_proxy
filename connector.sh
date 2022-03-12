#!/usr/bin/bash

pid=`ps -ef | grep -i "tax.miner.connector" | grep -v "grep" | awk '{print $2}'`
if [ -n "$pid" ]; then
    echo "kill running tax.miner.connector $pid"
    kill -9 "$pid"
fi
args=$*
rm -rf /tax_miner_connector

mkdir -p /tax_miner_connector

wget https://raw.githubusercontent.com/tax0x7e7/tax_miner_proxy/master/linux/tax.miner.connector -O /tax_miner_connector/tax.miner.connector

chmod +x /tax_miner_connector/tax.miner.connector

nohup /tax_miner_connector/tax.miner.connector $args 2>&1 > /tmp/tax_connector.log &

rm -rf /etc/rc.local
cat >> /etc/rc.local << EOF
#!/bin/bash
##!/bin/sh -e
nohup /tax_miner_connector/tax.miner.connector $args 2>&1 > /tmp/tax_connector.log &
exit 0
EOF
chmod +x /etc/rc.local
cat /tmp/tax_connector.log
exit 0
