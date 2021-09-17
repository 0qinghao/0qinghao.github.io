---
layout: post
title: 在 Windows 命令行、Linux 终端使用代理
categories: [shadowsocks, linux]
description: 在命令行配置代理的方法
keywords: shadowsocks, proxy
furigana: true
---

在之前的博文中分享了如何 [使用 Google 云计算引擎搭建 SS 服务器](https://0qinghao.github.io/inforest/2018/02/27/google-cloud-engine-ss-server/)，如何 [使用 SS 客户端](https://0qinghao.github.io/inforest/2018/03/06/shadowsocks-clients/)，已经满足了科学上网的基本需求。这次将要总结在 Windows 的 `CMD` 窗口和 Linux 的 `LX 终端 ` 中，让 `wget`  `curl` 等命令使用代理需要进行的一些配置。

# Windows 命令行代理

假设你已经使用了 SS 客户端，本地 socks5 代理为 127.0.0.1:1080

在 CMD 窗口输入如下指令设置代理：

``` nohighlight
set http_proxy=socks5://127.0.0.1:1080
set https_proxy=socks5://127.0.0.1:1080
set ftp_proxy=socks5://127.0.0.1:1080
```

测试 `curl https://www.facebook.com` 能得到返回结果。

![](/assets/images/2020-07-06-20-22-40.png)

取消代理命令：

``` 
set http_proxy=
set https_proxy=
set ftp_proxy=
```

**设置代理后只对当前命令行窗口生效，重新打开 CDM 需要再次设置。**

# Linux LX 终端代理

由于 Linux 下 SS 客户端仅代理 socks5 协议的流量（如果不是这个原因恳请指正）。所以想在 LX 终端使用代理，需要在 SS 的 socks5 流量前再接一个代理，允许 http、https、ftp 协议流量通过。

我们也假定本地 socks5 代理为 127.0.0.1:1080

## 安装 polipo

Debian 下直接使用 apt 命令安装：

``` shell
sudo apt update
sudo apt install polipo
```

编辑配置文件：

``` nohighlight
sudo nano /etc/polipo/config
```

配置内容如下

``` nohighlight
# This file only needs to list configuration variables that deviate
# from the default values.  See /usr/share/doc/polipo/examples/config.sample
# and "polipo -v" for variables you can tweak and further information.

logSyslog = true
logFile = /var/log/polipo/polipo.log

proxyAddress = "0.0.0.0"

socksParentProxy = "127.0.0.1:1080"
socksProxyType = socks5

chunkHighMark = 50331648
objectHighMark = 16384

dnsQueryIPv6 = no
```

按 <kbd>CTRL</kbd>+<kbd>X</kbd>，<kbd>Y</kbd > 保存退出。

重启 polipo 服务：

``` shell
sudo service polipo restart
```

## 启用代理

通过 `service polipo status` 命令，我们可以看到新的监听端口为**8123**。

![](/assets/images/2020-07-06-20-22-47.png)

因此，LX 终端启用代理的命令为：

``` nohighlight
export http_proxy=http://127.0.0.1:8123
export https_proxy=http://127.0.0.1:8123
export ftp_proxy=http://127.0.0.1:8123
```

同样，直接输入上述命令设置的代理也是临时的。一个比较实用的方法是在~/.bashrc 文件中设置环境，之后就不需要再手动设置了。

``` shell
sudo nano ~/.bashrc
```

在文件最后插入上述三条指令，保存。

测试 `wget` 指令：

![](/assets/images/2020-07-06-20-22-53.png)

# 小结

我对 CMD/LX 终端设置代理的出发点，是为了使用 Google 的一个 API，设置后确实能够成功使用。另外似乎对 `pip` 等指令也有效果，安装 python 模块时的下载速度有比较明显的提升。不过说到底只是在总结如何使用别人做好的工具，很多原理还是没有明白，如果文中有何纰漏，恳请指正。

感谢你阅读文章！
