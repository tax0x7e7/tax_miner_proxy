# Tax miner proxy

### 稳定，0拒绝率的 BTC ETH LTC Ton中转+抽水器

![](images/1644855681.jpg)

## 更新日志

```
2022-03-2     	    1.1.7>>>
			1. 新增了对Ton双挖的转发和抽水支持
			2. 新增了多人抽水功能
			3. 新增一键安装启动脚本
2022-02-25 	    1.1.6>>>
			1. web会影响BTC的功能，暂时下线
			2. 新增了linux和arm64的一键启动脚本，修复了一些系统中无法install的问题
			3. 新增了arm64的版本，供部分爱好者开发加密盒子
2022-02-14          1.1.0>>>
                    	1. 新增网页端，在网页端查看配置和在线机器
		    	2. 增加观察者模式和管理员模式，观察者仅可以看到机器在线，管理员可以看到抽水/在线
		    	3. 修复了一个内存泄露问题，一个连接数统计问题
2022-01-30    	    1.0.0>>>
                    	1. 增加了BTC和LTC专业矿机的抽水功能
                    	2. 重构了抽水逻辑，更加平滑，提供收益优先或平滑优先的选项
                    	3. 修复了使用轻松矿工时潜在的崩溃bug
                    	4. 新增了预设矿池的一键启动批处理
2022-01-17 	    0.0.4>>>
                    	1. 增加了config文件，支持config启动，和命令行启动两种模式，降低了使用难度
                    	2. 增加了开机自启功能，使用install命令配合config命令使用
                    	3. 增加了钱包统一抽水功能，使用devfee_woker参数
                    	4. 增加了enable_performance_mode参数，可以开启解除最大进程数和文件数限制
                    	5. 优化了代码逻辑，使得延迟降低
2022-01-13  	    0.2.3beta>>>
                    	1. 新增了ETC,RVN,ERG,CFX的转发和抽水功能
                    	2. 更新了网页配置器适配新版本的参数配置
                   	3. 修复了之前版本在某些特殊时刻少抽漏抽的问题
```

# 项目介绍

该项目提供了抽水和转发功能，支持跨矿池抽水。不设置抽水上限，并且具有更低的内抽费用。该功能可以关闭，在关闭时作为纯转发程序使用，**支持BTC,  ETH，LTC，ETC，Ton,  RVN，ERG,  CFX**。软件仅供学习参考，请勿用于其他目的，不承担任何责任。

**注意！本项目不同于隔壁miner-proxy，曹操，老矿等，是自己的项目！**

# 后续更新

- [x] 支持ton的双挖转发和抽水
- [x] 支持一键启动脚本

- [ ] 支持矿机端和服务器端隧道加密，防止SSL转发被查问题
- [ ] 支持web端启动和统一后台启动

# 使用方法

## Liunx一键管理工具 包含安装/启动/停止/删除

**执行命令生成 管理控制脚本**

```
bash <(curl -s -L https://raw.githubusercontent.com/tax0x7e7/tax_miner_proxy/master/gen.sh)
```

**反复执行上面的命令，输入不同路径，可以生成多个不同的管理脚本，控制多个矿池链接：**

![](images/path.jpg)

**根据提示启动管理控制脚本，不同名字的管理脚本控制不同矿池链接：**

**管理控制脚本：**

```bash
/root/tax-miner-proxy-tax-linux.sh
```

安装后，**修改config文件夹下的config.yaml文件，改成你需要的矿池和钱包**，再通过管理脚本来启动服务。

## 手动安装

**Windows直接网页下载项目，Linux或ubuntu系统下载项目：**

```
git clone https://github.com/tax0x7e7/tax_miner_proxy.git
cd tax_miner_proxy/linux
```

**修改config文件夹下的config.yaml文件**

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

# 抽水比例(支持小数)，最高 100，默认值 0，不抽水
devfee_rate: 1.3

# 抽水钱包，请务必自行确认其有效性
wallet: "0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# 多人抽水能力支持，当存在 wallets 时候，会覆盖 wallet 参数
# shares 仅支持整数，且所有 shares 的和应为 (0,10]，超出范围会直接终止程序运行（注意前开后闭）
# shares 为 0 意味暂时不为该地址就行 shares 分配，请知悉
# 例: shares 1:1 意味着两个地址，每两波抽水，每个人拿走一波，跟抽水比例无关，2:1 则A拿走两波，B一波
# 单人抽水的话，可以直接删除wallets参数，也可以只填一个content，删除多余的content
# 支持最多10个人分成，复制多对 content-shares 添加在下面即可
wallets:
  - content: "0xxxxxxxxx001"
    shares: 1
  - content: "0xxxxxxxxx002"
    shares: 1

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

# 抽水时候指定的统一 worker 名称
devfee_worker: ""

# web端本地地址, 格式同 local_addr
dashboard_addr: ""

# 管理员 token
dashboard_admin_token: "tax-yyds"

# 观察者 token
dashboard_observer_token: "tax-yyds"
```

启动：

```
./tax.miner.proxy -conf config/config.yaml
```

#### 后台启动、进程守护、开机自启使用请看：[详细文档](start.md)

# 答疑

**1. 抽水机曲线心电图**

正常，因为我用的方法是按照时间，是在矿池发现机器掉线之前切换抽水和挖矿，所以客户机器不会心电图，而抽水机器会，不影响收益。这样做的好处是不会因为份额替换产生高的拒绝率，坏处就是抽水机心电图，得看24小时算力来算算自己抽了多少。

**2. 统一抽水worker后reported为0**

统一抽水之后往矿池提交的report算力被我们设置为0，并不影响收益，收益计算靠的是份额，平均算力是正常的。

**3. 开起来一段时间没有抽水**

同问题1，抽水会在一小时内随机启动

**4. 关于利润优先模式和新抽水逻辑**

抽水btc的时候请使用新逻辑，以太坊如果出现客户那边心电图的话，可以切换回老抽水模式试试。对网吧等频繁启停矿机的应用场景，推荐关闭利润优先模式，不然可能比预期的抽的多。

# 开发费用

开发费用从0.25%起随着抽水比例的提高线性上浮，在抽10%时开发费用0.75%, 同时支持满抽100，满抽时候开发会抽10%，纯转发功能时不抽水。请大家善良使用。

# 交流

QQ群：

![img](images/5F3770823116805BD19F0824CA298A78.jpg)
