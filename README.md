# Tax miner proxy

## 使用方式

 **-devfee_rate int** 

​	抽水比例，最高 100，默认值 0，不抽水

 **-enable_client_ssl** 

​	是否启用**矿机端** SSL 加密**(如果内核里边使用 SSL 连接的话，需要设置这个选项)**

**-enable_server_ssl** 

​	是否启用**中转服务器端** SSL 加密(**大部分常用矿池已经自动进行了判断，无需特殊设置，若设置则优先级最高**)

**-enableDevFeeSSL**

​	是否启用**抽水** SSL 加密(大部分常用矿池已经自动进行了判断，无需特殊设置，若设置，则优先级最高)

**-eth_addr string** 

​	抽水 eth 钱包地址

**-devfee_addr**

​	抽水矿池地址(asia2.ethermine.org:5555)，不填写默认为转发矿池地址

 **-install** 

​	添加到系统服务, 并且开机自动启动

 **-l string**     

​	中转转发端口地址 (default ":9999")

**-r string**  

​	转发矿池地址 (default "asia2.ethermine.org:5555")



## 使用示例

### 连接SSL矿池(E池F池)，并使用双端ssl加密

前台启动：

```bash
./go.miner.proxy -l :1111 -r asia2.ethermine.org:5555 -enable_client_ssl -eth_addr 抽水钱包地址 --devfee_rate 5(抽水百分比，0到100的整数)
```

后台启动：

```bash
nohup ./go.miner.proxy -l :1111 -r asia2.ethermine.org:5555 -enable_client_ssl -eth_addr 抽水钱包地址 --devfee_rate 5(抽水百分比，0到100的整数) &
```

### 连接TCP矿池(币印鱼池)，并使用本地ssl加密

以币印为例：

```bash
./go.miner.proxy -l :2224 -r eth.ss.poolin.me:443 -enable_client_ssl -eth_addr 抽水钱包地址 -devfee_rate 5(抽水百分比，0到100的整数)
```

注意，默认情况下，不填写**devfee_addr**抽水矿池地址时，使用中转矿池地址作为抽水矿池

### 中转矿池和抽水钱包所在矿池不同时：

连接**tcp矿池并且本地加密**的同时，在**ssl矿池**进行抽水：

```bash
./go.miner.proxy -l :2224 -r eth.ss.poolin.me:443 -enable_client_ssl -devfee_addr asia2.ethermine.org:5555 -eth_addr 抽水钱包地址 -devfee_rate 5
```

中转**tcp矿池并且无加密**的同时，在**ssl矿池**进行抽水（**不推荐**）：

```bash
./go.miner.proxy -l :2224 -r eth.ss.poolin.me:443 -devfee_addr asia2.ethermine.org:5555 -eth_addr 抽水钱包地址 -devfee_rate 5
```

中转**SSL矿池**的同时，在**ssl矿池**进行抽水：

```bash
./go.miner.proxy -l :2224 -r asia2.ethermine.org:5555 -enable_client_ssl -devfee_addr asia2.ethermine.org:5555 -enableDevFeeSSL -eth_addr 抽水钱包地址 -devfee_rate 5
```

中转**SSL矿池**的同时，在**TCP矿池**进行抽水 （**不推荐**）：

```bash
./go.miner.proxy -l :2224 -r asia2.ethermine.org:5555 -enable_client_ssl -devfee_addr eth.ss.poolin.me:443 -eth_addr 抽水钱包地址 -devfee_rate 5
```

### 仅做转发使用，不抽水

```
./go.miner.proxy -l :2224 -r asia2.ethermine.org:5555 -enable_client_ssl 
```

### 开发抽水

在<10%抽水时，从0.3%起步到最大0.8%

在<20%抽水时，从0.8%起步到最大2%

无抽水上限，大家善良使用。