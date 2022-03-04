#!/bin/bash

#>>>>>>>>>>>>>>>>>>> tax.miner.proxy 安装目录配置 <<<<<<<<<<<<<<<<<<<<<<<
# 默认情况下不要修改，如果需要进行 tax.miner.proxy 多开时候（不熟悉 linux 系统的话，强烈不建议多开）
# 复制一份本文件，然后再修改这个路径
# 不要修改 /root/ 部分， tax_miner_proxy 部分可以修改，但是不要写中文进去
# 不要直接修改这个文件，不要直接使用默认的监听端口
dirname="/root/tax_miner_proxy"


#>>>>>>>>>>>>>>>>>>>>>>>> 下面内容请不要修改<<<<<<<<<<<<<<<<<<<<

[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi

download() {
    if [ -d "$dirname" ]; then
        echo -e "您已安装了 tax_miner_proxy, 如果确定没有安装,请输入rm -rf $dirname" && exit 1
    fi
    $cmd update -y
    $cmd install curl wget -y

    wget https://raw.githubusercontent.com/tax0x7e7/tax_miner_proxy/master/linux/tax.miner.proxy -O $dirname/tax.miner.proxy
    wget https://raw.githubusercontent.com/tax0x7e7/tax_miner_proxy/master/linux/config.yaml -O $dirname/config.yaml

    echo "下载完成，请在修改默认配置文件后，使用 install 进行系统守护进程的安装"

}

update() {
    $cmd update -y
    $cmd install curl wget -y

    wget https://raw.githubusercontent.com/tax0x7e7/tax_miner_proxy/master/linux/tax.miner.proxy -O $dirname/tax.miner.proxy

    echo "更新完成，请重新执行安装"

}

install() {
      echo "正在使用 $dirname/config.yaml 中的配置"

      chmod 777 $dirname/tax.miner.proxy

      echo "如果没有报错则安装成功"

      cd $dirname

      echo "正在移除旧的进程守护配置文件，这部分失败了需要手动去 /etc/systemd/system 中删除一下"
      echo "--------->>>>>>>>>>移除旧配置文件<<<<<<<<<<<<<<<<------------"
      ./tax.miner.proxy -conf $dirname/config.yaml --remove
      echo "--------->>>>>>>>>>移除旧配置文件<<<<<<<<<<<<<<<<------------"
      echo "旧系统配置文件移除成功"
      ./tax.miner.proxy -conf $dirname/config.yaml --install
      sleep 1s

      echo "系统自启动服务安装成功，如果需要启动，请使用 start 命令"
}
uninstall() {
    read -p "是否确认删除tax.miner.proxy[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            cd $dirname
            ./tax.miner.proxy -conf $dirname/config.yaml --stop
            ./tax.miner.proxy -conf $dirname/config.yaml --remove
            rm -rf $dirname
            echo "卸载tax.miner.proxy成功"
        fi
    fi
}
start() {
    cd $dirname
    ./tax.miner.proxy -conf $dirname/config.yaml --start

    echo "tax.miner.proxy启动成功"
}


restart() {
    cd $dirname
    ./tax.miner.proxy -conf $dirname/config.yaml --restart

    echo "tax.miner.proxy已重新启动"
}
stat() {
    cd $dirname
    ./tax.miner.proxy -conf $dirname/config.yaml --stat

}

stop() {
     cd $dirname
     ./tax.miner.proxy -conf $dirname/config.yaml --stop
     echo "tax.miner.proxy 已停止"
}

echo "======================================================="
echo "tax.miner.proxy 一键工具"
echo "  0、下载(下载到$dirname，务必在下载后，修改 $dirname/config.yaml)"
echo "  1、安装（务必在下载后，修改 ）"
echo "  2、卸载（移除 tax.miner.proxy）"
echo "  3、启动（安装后默认使用 systemd 进行进程守护，并进行启动）"
echo "  4、重启（修改完配置文件内容后，请重启）"
echo "  5、停止（停止tax.miner.proxy 运行）"
echo "  6、查看运行状态"
echo "  7、更新"
echo "======================================================="
read -p "$(echo -e "请选择[0-6]：")" choose
case $choose in
0)
    download
    ;;
1)
    install
    ;;
2)
    uninstall
    ;;
3)
    start
    ;;
4)
    restart
    ;;
5)
    stop
    ;;
6)
    stat
    ;;
7)
    update
    ;;
*)
    echo "输入错误请重新输入！"
    ;;
esac
