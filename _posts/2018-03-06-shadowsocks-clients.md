---
layout: post
title: Shadowsocks 客户端在不同系统下的使用方法
categories: [shadowsocks, linux]
description: 记录 ss 客户端使用的水文，后期换了更强大的 clash
keywords: shadowsocks
furigana: true
---

当我们配置好 Shadowsocks 服务器端，或是购买了 SS 账号后，就可以使用客户端开始科学上网了。下面分别介绍在 Windows、安卓、Linux(Debian) 系统下 SS 客户端的使用方法。

# Windows 系统下 SS 客户端的使用方法

Windows 系统下的 SS 客户端使用起来最为方便。客户端自带了系统全局代理的功能，甚至可以省去配置浏览器插件的操作。

## 下载客户端

* [点击这里，跳转到 GitHub 下载](https://github.com/shadowsocks/shadowsocks-windows/releases)
* [如果你无法打开 GitHub，可以点击这里，前往微云下载，但不保证是最新版本](https://share.weiyun.com/edaa2c5f08aa5169c2be5c6a9f59662d)

将压缩包内的可执行程序解压，放置在合适的文件夹内，运行后会在程序同一目录下产生配置文件，如果随便放置容易显得杂乱。

## 配置客户端

第一次打开 SS 客户端会主动要求编辑服务器。填入你的 **` 服务器地址 `** **` 密码 `** **` 服务器端口号 `** **` 加密方式 `** ，其他设置可以保持默认。

![](/assets/images/2020-07-06-19-29-24.png)

最后，右击任务栏的小图标，勾选 **` 启用系统代理 `** 。系统代理模式选择 **`PAC 模式 `** ，这样 SS 会自动使用代理访问墙外站点，不需要另外安装浏览器的代理插件。

![](/assets/images/2020-07-06-19-29-55.png)

# 安卓系统下 SS 客户端的使用方法

安卓系统下的 SS 客户端也很完善，配置方便，甚至还可以指定仅部分 APP 使用代理。

## 下载客户端

* 如果你能使用 Google Play 商店，直接搜索安装 [Shadowsocks](https://play.google.com/store/apps/details?id=com.github.shadowsocks)
* [你也可以点击这里，前往微云下载，但不保证是最新版本](https://share.weiyun.com/f9250253dab9ec9ba9b12e124733adcd)

## 配置客户端

点击右上角的 `+` 选择 ` 手动设置 ` ，填入你的 **` 服务器地址 `** **` 密码 `** **` 服务器端口号 `** **` 加密方式 `** ，其他设置可以保持默认。

![](/assets/images/2020-07-06-19-30-11.png)

还可以在配置中开启 ` 分应用 VPN` 功能，来指定仅部分 APP 的流量进行代理；或者再打开 ` 绕行模式 ` 来指定部分 APP 的流量绕过代理。

# Debian 下 SS 客户端的使用方法

Linux 下使用 SS 客户端要麻烦一些，一方面 Linux 下 SS 不带全局代理，需要搭配浏览器插件使用；另一方面笔者在使用中有遇到 bug，不知在你阅读这篇文章时是否已经修复，总之还是会记录在下文中以供参考。

另外，这部分介绍的是配合 Chrome 插件实现浏览器翻墙的方法。关于如何在 LX 终端让 `wget`  `curl` 等命令使用代理，将在另一篇文章中再做总结。

## 安装客户端

``` shell
sudo apt update
sudo apt install shadowsocks
```

## 运行 sslocal

不带任何参数运行 `sslocal` 可以查看帮助。

运行 SS 客户端一般有两种方法。你可以参考帮助，将必要的参数填入，用一条较长的指令来运行：

``` shell
sudo sslocal -s 服务器地址 -p 服务器端口 -k 密码 -m 加密方式 -d start
```

显然上面这种方式效率太低。另一种方式就是将各项参数保存为 json 文件，运行时指定配置文件即可。

假设我们的配置文件是 `/etc/ss.json` ，其内容为：

``` nohighlight
{
  "server":"服务器地址",
  "server_port": 服务器端口,
  "local_address":"127.0.0.1",
  "local_port":1080,
  "password":"密码",
  "timeout":600,
  "method":"加密方式",
  "fast_open":false
}
```

将你的 **` 服务器地址`** **` 密码`** **` 服务器端口号`** **` 加密方式`** 替换到上述文件。（有双引号的请保留双引号，不要删除）

接下来，每次需要运行 SS 客户端时，我们只需要输入一条简短的指令：

``` shell
sudo sslocal -c /etc/ss.json -d start
```

### * 运行 sslocal 时遇到的 bug

> 解决方案来自 [Kali2.0 update 到最新版本后安装 shadowsocks 服务报错问题](http://blog.csdn.net/blackfrog_unique/article/details/60320737)

笔者在运行 sslocal 命令时遇到了形如 *INFO loading libcrypto from libcrypto.so.1.1* 的报错。后在上述文章中找到解决方案。

打开文件 openssl.py，请参照错误提示确定是否与下述文件路径相同：

``` nohighlight
sudo nano /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py
```

使用快捷键 <kbd>CTRL</kbd>+<kbd>_</kbd > 选择跳转到第 52 行

将 *libcrypto. EVP_CIPHER_CTX_ `cleanup` .argtypes = (c_void_p, )* 修改为 *libcrypto. EVP_CIPHER_CTX_ `reset` .argtypes = (c_void_p, )*

同样地，跳转到第 111 行

将 *libcrypto. EVP_CIPHER_CTX_ `cleanup` (self.ctx)* 修改为 *libcrypto. EVP_CIPHER_CTX_ `reset` (self._ctx)*

按 <kbd>CTRL</kbd>+<kbd>X</kbd>，<kbd>Y</kbd > 保存退出。重新执行 sslocal 指令运行正常。

## 安装 Chrome 插件

由于 Linux 下的 SS 客户端不带全局代理功能，需要配合浏览器插件使用。这里只介绍 Chrome 插件的安装方法，火狐大体上类似。

如果你能够使用 Chrome 应用商店，搜索 [SwitchyOmega](https://chrome.google.com/webstore/search/switchyomega?hl=zh-CN) 安装即可。你也可以点击 [这里](https://share.weiyun.com/28d769f6e52b68b894736b54b29cf9e4) 通过微云下载 crx 文件，将其拖动到 [Chrome 扩展程序页面](chrome://extensions/) 完成安装。

![](/assets/images/2020-07-06-19-30-31.png)

点击选项，如下图配置 SwitchyOmega。 ` 代理协议 ` 选择 `SOCKS5` ；如果你在 ss.json 配置文件中修改过 `local_port` 参数，则这里 ` 代理端口 ` 必须与其一致，否则保持默认值 1080 即可。

![](/assets/images/2020-07-06-19-30-42.png)

最后，保存配置，点击 SwitchyOmega 图标切换到刚才配置好的情景模式。

![](/assets/images/2020-07-06-19-30-52.png)

# 结语

由于手上设备有限，没办法总结所有系统下的 SS 客户端使用方法。例如 iOS 系统下似乎是使用 [Big Boss 源](http://apt.thebigboss.org/onepackage.php?bundleid=com.linusyang.shadowsocks) 搜索 ShadowSocks 应用，但没法亲自尝试。有兴趣的朋友建议前往官网 https://shadowsocks.org/（.com 那个是出售 SS 服务的）进一步了解。

感谢你阅读文章！
