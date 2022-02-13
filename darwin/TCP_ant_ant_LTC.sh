#!/bin/bash
CURDIR=$(cd "$(dirname $0)" || exit; pwd)

CONF_FILE=$CURDIR/config/TCP_ant_ant_LTC.yaml

args=""

BinaryName="tax.miner.proxy"
echo "欢迎使用 taxMinerProxy，如果需要开启性能模式（解除 ulimit），请在 root 账户下或者使用 sudo 权限"
echo "$CURDIR"/${BinaryName}  -conf $CONF_FILE

exec "$CURDIR"/${BinaryName} -conf $CONF_FILE
