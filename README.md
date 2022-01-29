# Tax miner proxy

### 稳定，0拒绝率的 BTC ETH LTC中转+抽水器

**1.30日更新1.0.0 (重要更新)**

```
1. 增加了BTC和LTC专业矿机的抽水功能
2. 重构了抽水逻辑，更加平滑，提供收益优先或平滑优先的选项
3. 修复了使用轻松矿工时潜在的崩溃bug
4. 新增了预设矿池的一键启动批处理
```

**1.17日更新 0.4.0:**

 	1. 增加了config文件，支持config启动，和命令行启动两种模式，降低了使用难度
 	2. 增加了开机自启功能，使用install命令配合config命令使用
 	3. 增加了钱包统一抽水功能，使用devfee_woker参数
 	4. 增加了enable_performance_mode参数，在linux和mac系统下可以开启解除最大进程数和文件数限制
 	5. 优化了代码逻辑，使得延迟降低

**1.13日更新 0.2.3beta：**

```
1. 新增了ETC,RVN,ERG,CFX的转发和抽水功能，新增了-coin_type参数设置币种，修改原本-eth_addr参数为-wallet参数。
2. 更新了网页配置器适配新版本的参数配置
3. 修复了之前版本在某些特殊时刻少抽漏抽的问题
```

# 项目介绍

该项目提供了抽水和转发功能，支持跨矿池抽水。不设置抽水上限，并且具有更低的内抽费用，并且不会因为抽水产生拒绝率。该功能可以关闭，在关闭时作为纯转发程序使用，**支持BTC,  ETH，LTC，ETC，RVN，ERG,  CFX**。

软件仅供学习参考，请勿用于其他目的，不承担任何责任。

**注意！本项目不同于隔壁miner-proxy，曹操，老矿等，是自己的项目！**

# 后续更新

- [x] 支持ETC,RVN,ERG,CFX的转发和抽水
- [x] 支持开机自启和config文件启动模式
- [x] 支持BTC，LTC专业矿机的转发和抽水
- [ ] 支持矿机端和服务器端隧道加密，防止SSL转发被查问题
- [ ] 支持web端监控转发和抽水状态

# 使用方法

**Windows直接网页下载项目，Linux或ubuntu系统下载项目：**

```
git clone https://github.com/tax0x7e7/tax_miner_proxy.git
cd tax_miner_proxy/linux
```

## 1. 预设快捷启动

我们为linux和windows用户都提供了预设快捷启动的方式，在windows和linux文件夹分别可以看到大量的**.bat脚本和.sh脚本**，这些预设脚本已经配置好了矿池信息等，只要填写正确挖矿钱包即可启动。

预设对照表：

| 文件名            | 含义                                                         |
| ----------------- | ------------------------------------------------------------ |
| SSL_E_E_ETC       | 矿机连接模式：SSL，转发矿池：E池，抽水矿池：E池，币种：ETC   |
| SSL_E_E_ETH       | 矿机连接模式：SSL，转发矿池：E池，抽水矿池：E池，币种：ETH   |
| TCP_ant_ant_BTC   | 矿机连接模式：TCP，转发矿池：蚂蚁，抽水矿池：蚂蚁，币种：BTC |
| TCP_ant_ant_ETC   | 矿机连接模式：TCP，转发矿池：蚂蚁，抽水矿池：蚂蚁，币种：ETC |
| TCP_ant_ant_LTC   | 矿机连接模式：TCP，转发矿池：蚂蚁，抽水矿池：蚂蚁，币种：LTC |
| TCP_ant_E_ETH     | 矿机连接模式：TCP，转发矿池：蚂蚁，抽水矿池：E池，币种：ETH  |
| TCP_by_by_BTC     | 矿机连接模式：TCP，转发矿池：币印，抽水矿池：币印，币种：BTC |
| TCP_fish_fish_BTC | 矿机连接模式：TCP，转发矿池：鱼池，抽水矿池：鱼池，币种：BTC |
| TCP_fish_E_ETH    | 矿机连接模式：TCP，转发矿池：鱼池，抽水矿池：E池，币种：ETH  |

在**config文件夹**中有和这些预设脚本**同名的配置文件**，修改**配置yaml文件**中的端口、钱包、抽水比例即可自定义启动:

```bash
# 程序本地转发端口
local_addr: ":9998"

# 抽水钱包，请务必自行确认其有效性
wallet: "0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# 抽水比例(支持小数)，最高 100，默认值 0，不抽水
devfee_rate: 2
```

Windows启动双击对应的bat脚本即可

```
双击SSL_E_E_ETH.bat(改成你想启动的脚本名字)
```

Linux启动:

```bash
./SSL_E_E_ETH.sh(改成你想启动的脚本名字)
```

## 2. 完整配置config.yaml方式启动

```bash
# 代币类型，目前支持：eth/etc/rvn/erg/cfx/btc/ltc/scp/ltc
coin_type: "eth"

# 程序本地转发端口
local_addr: ":9998"

# 是否启用客户端 SSL 加密, 如果内核里边使用 SSL 连接的话，需要设置这个选项为 true
enable_client_ssl: true

# 远程代理地址，常用地址（E池/鱼池/币印等）已经内置 SSL/TCP 判断
remote_addr: "asia2.ethermine.org:5555"

# 是否启用服务端 SSL 加密
# 大部分常用矿池已经自动进行了判断，无需特殊设置，若设置为 true，则优先级最高
enable_server_ssl: false

# 抽水钱包，请务必自行确认其有效性
wallet: "0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# 开启性能模式：解除 ulimit -n 1024 限制, Windows为关，Linux为开
enable_performance_mode: false

# 开启利润优先模式，默认为 true, 开启此模式后，会优先保证抽水收益，可能会导致抽水比例略微超过设定值
# NOTICE：如果机器频繁掉线，不建议开启
enable_profit_mode: true

# 开启新抽水逻辑，低于 6% 建议使用新逻辑，会让算力曲线更加平稳, 高抽水比例时，关闭此项可能会提抽水收益
is_experiment_devfee: true

# 抽水矿池地址，默认使用转发矿池地址
devfee_addr: ""

# 是否启用抽水 SSL 加密, 大部分常用矿池已经自动进行了判断，无需特殊设置，若设置 true，则优先级最高
enable_devfee_ssl: false

# 抽水比例(支持小数)，最高 100，默认值 0，不抽水
devfee_rate: 10.3

# 抽水时候指定的统一 worker 名称
devfee_worker: ""
```

**Linux一键启动脚本，默认启动```config.yaml```**

```bash
./bootstrap.sh
```

**Windows下直接双击```bootstrap.bat```**

```
bootstrap.bat
```

**指定config文件模式，指定不同config来启动多个端口**

```bash
./tax.miner.proxy -conf config.yaml
```

**若config文件是上传的可能会报权限问题```Permission denied```，执行：**

```bash
chmod u+x *
```

### 3. [命令行传参方式启动](old_readme.md)

命令行启动方式点击上面连接查看详细解释，[配置生成器网页](https://adoring-agnesi-3aae50.netlify.app/)

### 4. 后台启动

测试成功后可以``ctrl+c``杀死进程后，使用**后台启动**：

```
nohup ./tax.miner.proxy -conf config.yaml&
```

即可后台运行，这样可以实现关掉命令行窗口后，矿机依然可以连上节点，保持抽水和中转的运行。

查看后台运行情况

```bash
tail -f /tmp/tax_proxy--端口.stat.log
```



### 5. 开机自启

执行pwd获取当前路径，并复制输出

```
pwd
```

执行:

```
./tax.miner.proxy -conf pwd的结果/config.yaml -install
```

取消开机自启：

```
./tax.miner.proxy -conf pwd的结果/config.yaml -remove
```

# 开发费用

开发费用从0.25%起随着抽水比例的提高线性上浮，在抽10%时开发费用0.75%, 同时支持满抽100，满抽时候开发会抽10%，请大家善良使用。

# 交流

QQ群：

![img](images/5F3770823116805BD19F0824CA298A78.jpg)