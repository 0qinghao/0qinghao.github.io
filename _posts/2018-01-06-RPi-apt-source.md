---
layout: post
title: 树莓派学习手记——修改软件源
categories: [raspberrypi, linux]
description: 可以说是我的第一篇博客，当时试水用的，简单描述了树莓派 apt 软件源的问题
keywords: 树莓派, 软件源, apt
furigana: true
---

## 国情，国情

在 Raspbian/Ubuntu 系统上，升级系统或安装软件只需要一条很简单的命令：

``` nohighlight
sudo apt install 软件包名		# 安装软件
sudo apt upgrade		# 更新软件
```

然而在天朝的网络下，很难顺利地完成下载过程。但好在有许多高校 / 机构提供了及时更新的镜像网站，我们可以通过修改配置文件解决下载难的问题。

很多同学查找解决方法后，或许能解决一部分问题，但仍会遇到连接超时的问题。究其原因，大致有两点：

* **树莓派的软件源配置有两处，而大部分教程只指出了一处；**

* **没有区分系统版本（Codename），Codename 目前分为 jessie / wheezy / squeeze / stretch，大部分教程仍使用的是 jessie 或 wheezy，而笔者安装的系统却是 stretch。**

  ​

## 配置文件在哪

``` nohighlight
/etc/apt/sources.list
/etc/apt/sources.list.d/raspi.list
```

很多教程只指出了第一处，如果没有修改第二个配置文件，更新系统时很容易出现连接超时的问题。

在修改配置文件之前，可以选择先备份一下原文件，但这个配置文件也不太重要，不想麻烦也可跳过。

``` nohighlight
sudo cp /etc/apt/sources.list /etc/apt/sources.bak
sudo cp /etc/apt/sources.list.d/raspi.list /etc/apt/sources.list.d/raspi.bak
```

  ​

## 我的 Codename 是什么

我们来确定自己树莓派安装的系统 Codename 是什么：

``` nohighlight
lsb_release -a
```

运行这条指令之后，可以很清楚的看到 Codename

``` shell
Codename: stretch
```

  ​

## 修改配置文件

国内有许多高校提供了树莓派的软件源镜像。可以在这个网页查看所有的镜像网站：http://www.raspbian.org/RaspbianMirrors

笔者选择了中科大提供的镜像，也是大家公认的比较稳定的镜像之一。

----------

``` nohighlight
sudo nano /etc/apt/sources.list
```

将该文件的内容替换为：

``` nohighlight
deb http://mirrors.ustc.edu.cn/raspbian/raspbian/ stretch main contrib non-free
deb-src http://mirrors.ustc.edu.cn/raspbian/raspbian/ stretch main contrib non-free
```

按 <kbd>CTRL</kbd>+<kbd>X</kbd> 关闭文件，键入 <kbd>Y</kbd>（保存修改）回车。

修改第二个配置文件：

``` nohighlight
sudo nano /etc/apt/sources.list.d/raspi.list
```

类似地，内容替换为：

``` nohighlight
deb http://mirrors.ustc.edu.cn/archive.raspberrypi.org/ stretch main ui
deb-src http://mirrors.ustc.edu.cn/archive.raspberrypi.org/ stretch main ui
```

**相信细心的同学已经注意到了，修改的文件内容网址后紧接着一项 "stretch"。如果你手中的树莓派安装的系统 Codename 并不是 stretch，还请进行相应修改。**

----------

最后，刷新软件列表：

``` nohighlight
sudo apt update
```

修改完成了！赶紧去体验一下高速更新系统 / 升级软件的快感吧。感谢你阅读文章！
