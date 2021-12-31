# Tax miner proxy

该项目用于矿池的中转代理转发，解决连不上矿池和境外矿池延迟过高等问题。

该项目提供了抽水功能，支持跨矿池抽水。不设置抽水上限，并且具有更低的内抽费用。该功能可以关闭，在关闭时作为纯转发程序使用。

软件仅供学习参考，请勿用于其他目的，不承担任何责任。

**注意！本项目不同于隔壁miner-proxy，曹操，老矿等，是自己的项目！**

## 使用方法

### 1. 下载软件

​	[Linux版本](https://github.com/tax0x7e7/tax_miner_proxy/tree/master/linux)

​	[Windows版本](https://github.com/tax0x7e7/tax_miner_proxy/tree/master/windows)

​	[Mac版本](https://github.com/tax0x7e7/tax_miner_proxy/tree/master/mac)

1. 可以直接下载对应版本使用

2. 对于linux服务器没有图形界面，首先：

   ```
   git clone https://github.com/tax0x7e7/tax_miner_proxy.git
   ```

   下载好项目后：

   ```
   cd tax_miner_proxy_master/linux
   ```

   之后按照**命令启动**

### 2.  命令启动

我们准备了一个[配置生成器](https://adoring-agnesi-3aae50.netlify.app/)来帮助使用，点击连接可以进入网页

![image-20211230110720130](images\config.jpg)

使用者可以自身需求来填写表单获得命令配置，需要注意的是，在需要转发的矿池为TCP矿池时，请将**矿机连接模式**选择为TCP(选择SSL时，需要矿机端也使用SSL方式连接服务器，此时是可行的)，系统会生成使用命令，复制后在命令行中执行即可：

![image-20211230112311851](images/generate.jpg)

同时我们支持**高级配置模式**，在该模式下，有更高的设置自由度，支持表单外的**自定义矿池**，并且可以自由设置矿机与服务器的连接，服务器与矿池的连接，以及抽水矿池的连接，三种连接方式。

![image-20211230112835466](D:\program\go_program\tax-miner-proxy\images\high.jpg)

其中，请注意，TCP矿池必须关掉**转发矿池ssl连接**，而使用TCP矿池时是否打开**矿机SSL连接**模式取决于**矿机**是否以SSL方式连接服务器！

矿机与服务器的连接： ![image-20211230113136970](C:\Users\10067\AppData\Roaming\Typora\typora-user-images\image-20211230113136970.png)

服务器与矿池的连接：![image-20211230113053340](D:\program\go_program\tax-miner-proxy\images\image-20211230113053340.png)

抽水矿池的连接：![image-20211230113146331](C:\Users\10067\AppData\Roaming\Typora\typora-user-images\image-20211230113146331.png)

### 3. 启动

在命令行输入刚才生成的指令启动服务，启动后会提示本地监听端口，抽水比例等，并且会提示上线的机器的ip和矿机名。

![image-20220101021438460](D:\program\go_program\tax-miner-proxy\images\image-20220101021438460.png)

启动后，会循环刷新当前在线的矿机数量，后上线的矿机也会提示启动。

![image-20220101021345829](D:\program\go_program\tax-miner-proxy\images\image-20220101021345829.png)

## 附加解释和使用示例

### 1. 命令参数解释

 **-devfee_rate**

​	抽水比例，最高 100，可以设置小数，默认值 0，不抽水

 **-enable_client_ssl** 

​	是否启用**矿机端** SSL 加密**(如果内核里边使用 SSL 连接的话，需要设置这个选项)**

**-enable_server_ssl** 

​	是否启用**服务器端** SSL 加密(**大部分常用矿池已经自动进行了判断，无需特殊设置，若设置则优先级最高**)

**-enable_devfee_ssl**

​	是否启用**抽水** SSL 加密(大部分常用矿池已经自动进行了判断，无需特殊设置，若设置，则优先级最高)

**-eth_addr**

​	抽水 eth 钱包地址

**-devfee_addr**

​	抽水矿池地址(asia2.ethermine.org:5555)，不填写默认为转发矿池地址

 **-install** 

​	添加到系统服务, 并且开机自动启动

 **-l **     

​	中转转发端口地址 (default ":9999")

 **-r**

​	转发矿池地址 (default "asia2.ethermine.org:5555")

下面是一些使用示例：

### 2. 使用示例 (搞不明白的话就使用[网页配置生成器](https://adoring-agnesi-3aae50.netlify.app/))

##### 连接SSL矿池(E池F池)，并使用双端ssl加密

前台启动：

```bash
./go.miner.proxy -l :1111 -r asia2.ethermine.org:5555 -enable_client_ssl -eth_addr 抽水钱包地址 --devfee_rate 5(抽水百分比，0到100，支持浮点数)
```

后台启动：

```bash
nohup ./go.miner.proxy -l :1111 -r asia2.ethermine.org:5555 -enable_client_ssl -eth_addr 抽水钱包地址 --devfee_rate 5(抽水百分比，0到100的，支持浮点数) &
```

##### 连接TCP矿池(币印鱼池)，并使用本地ssl加密(需要矿机端配合ssl模式连接)

以币印为例：

```bash
./go.miner.proxy -l :2224 -r eth.ss.poolin.me:443 -enable_client_ssl -eth_addr 抽水钱包地址 -devfee_rate 5(抽水百分比，0到100，支持浮点数)
```

注意，默认情况下，不填写**devfee_addr**抽水矿池地址时，使用中转矿池地址作为抽水矿池

##### 中转矿池和抽水钱包所在矿池不同时：

中转**TCP**矿池并且本地加密的同时，在**SSL矿池**进行抽水**(需要矿机端配合ssl模式连接)**：

```bash
./go.miner.proxy -l :2224 -r eth.ss.poolin.me:443 -enable_client_ssl -devfee_addr asia2.ethermine.org:5555 -eth_addr 抽水钱包地址 -devfee_rate 5
```

中转**TCP**矿池并且无加密的同时，在**SSL矿池**进行抽水：

```bash
./go.miner.proxy -l :2224 -r eth.ss.poolin.me:443 -devfee_addr asia2.ethermine.org:5555 -eth_addr 抽水钱包地址 -enable_devfee_ssl -devfee_rate 5
```

中转**SSL矿池**的同时，在**SSL矿池**进行抽水：

```bash
./go.miner.proxy -l :2224 -r asia2.ethermine.org:5555 -enable_client_ssl -devfee_addr asia2.ethermine.org:5555 -enable_devfee_ssl -eth_addr 抽水钱包地址 -devfee_rate 5
```

中转**SSL矿池**的同时，在**TCP矿池**进行抽水：

```bash
./go.miner.proxy -l :2224 -r asia2.ethermine.org:5555 -enable_client_ssl -devfee_addr eth.ss.poolin.me:443 -eth_addr 抽水钱包地址 -devfee_rate 5
```

##### 仅做转发使用，不抽水

```
./go.miner.proxy -l :2224 -r asia2.ethermine.org:5555 -enable_client_ssl 
```

### 3. 注意点

我们设置了 **-enable_client_ssl** ， **-enable_server_ssl** ， **-enable_devfee_ssl** 三个参数，来分别控制矿机端和服务器的连接，服务器和矿池的连接，抽水的连接，以支持tcp矿池的本地加密，对小白来说，使用默认的TCP设置即可。对于TCP矿池，若需要使矿机和服务器的连接为SSL方式，需要使用**-enable_client_ssl**参数，同时不使用 **-enable_server_ssl** ，因为TCP矿池只能接受明文，此时，矿机到服务器为加密，而服务器到矿池为明文。

## 捐赠

觉得好用的话请支持我们一下！接受USDT捐赠，TRC20链：TDzi3jDPLDbwAquhg1NTg4eXBief1KEG3J

## 交流

Tel群：

[https://t.me/+He1kH3u80cQ1MTk1](https://t.me/+He1kH3u80cQ1MTk1)

QQ群：

![img](D:\program\go_program\tax-miner-proxy\images\5F3770823116805BD19F0824CA298A78.jpg)