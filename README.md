## 简介

happynet是happyn.cc 提供的组建虚拟局域网的客户端工具， 这是MacOS版本;

## 系统要求

* MacOS 10, MacOS11

## build from

项目基于[N2N](https://github.com/happynlab/n2n)

upstream form n2n 2.9.0 macOS build by happyn.cc


## 安装


### 安装tuntap驱动

happyn依赖于网络TAP虚拟网卡,所以需要首先安装驱动

1. 安装Homebrew工具管理服务(如果您之前安装了brew工具套件,请跳过此步)

```
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```

2. 安装网卡驱动

如果是MacOS 11系统，请执行

```
brew install --cask  tuntap
```

如果是MacOS 10系统，请执行

```
brew install tuntap
```

3. 由于安全性的需要，安装时如果出现鉴定或者安全性警告，请输入管理员密码通过，或者是打开 `系统偏好设置` 中的 `安全性与隐私`，通过操作。

点击允许后，再次执行安装命令，系统可能提示需要重新启动生效;


### 安装自定义系统服务


1. 到[发布页面](https://github.com/happynclient/happynmacos/releases)直接下载我们最新的安装包


2. 解压安装包

```
tar zxvf happynet-macos-darwin-amd64-0.2.tar.gz
```

3. 打开终端,将可执行文件,配置文件,系统服务文件拷贝到相应的路径

```
sudo mkdir  -p /usr/local/bin
sudo mkdir -p /usr/local/etc
sudo mkdir -p /usr/local/var/log
cd happynet-macos-darwin-amd64-0.2

sudo chmod +x bin/happynet
sudo cp bin/happynet /usr/local/bin/
sudo cp conf/happynet.conf /usr/local/etc/
service/happynet.plist /Library/launchAgents/cc.happyn.happynet.plist
```

4. 修改配置文件,您需要填入的4个参数(从您的happyn.cc web端后台登录可以获取):

```
sudo vim /usr/local/etc/happynet.conf
```

* 本地地址：您的虚拟服务子网IP地址，ip网段从web界面可查，如图所示，这个服务子网为10.251.56.0/24，您可以设定从 10.251.56.1 -- 10.251.56.254 任意地址，只要保证每台机器不冲突即可

* 服务ID：从后台web界面可以得到，是分配给每个用户的唯一子网标识

* 服务密钥：从后台web界面可以得到, 是系统为您的分配的子网token，您可以自己设定，但是只有相同 "服务ID+服务密钥"的机器才能互通

* 服务器端口：从后台web界面可以得到

5. 载入服务

```
sudo launchctl load -w /Library/launchAgents/cc.happyn.happynet.plist
```

6. 如果系统提示 `无法打开程序,无法验证开发者`; 请打开 `系统偏好设置`>`安全性与隐私`>`通用`，这个时候有个按钮，仍然允许点击即可。

7. 启动服务

```
sudo launchctl start /Library/launchAgents/cc.happyn.happynet.plist
```

8. 查看log

```
tail -f /usr/local/var/log/happynet.log
```

9. 停止服务

```
sudo launchctl kill 15 system/happynet
```

## FAQ:

* 客户端支持哪些平台?

目前支持主流MacOS 64位系统；

* 我所有设备上的程序已经显示运行成功，但是我Ping不通对方，为什么？

首先请检查是否参数都正确配置了，特别要保证 "服务ID+服务密钥" 是否在所有客户端都一致，有很多时候是我们太粗心;

其次请检查自己的机器是否开启了防火墙，可以先用机器的原有IP Ping一下，看看通不通；

最后请仔细检查Happyn2n的输出Log，看是否有"[OK]"的连接成功输出，如果没有，最大的可能是您短时间内多次连接，被系统判断为恶意扫描禁止了；此时您先点击“停止”，然后等待2分钟，再次重连即可

* 还有其它问题？

没关系，请到我们的[交流论坛](https://forum.happyn.cc/t/macos) 向我们反馈问题，谢谢您的包容和支持！
