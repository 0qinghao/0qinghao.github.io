---
layout: post
title: 获取 /dev/sdx 设备的 UUID 和 USB Version 等信息
categories: [linux]
description: 获取 U 盘的详细信息，最重要的是能直接获取 sda 设备是 usb 2.0 还是 3.0
keywords: dev, sda, uuid, usb speed, usb 2.0, usb 3.0
furigana: false
---

同事碰到一个痛点，在做板上测试时插入了多个 U 盘，由于 Linux 系统对接入设备的枚举命名，即 sda/sdb...sdf。通过热拔插确实可以确定一次，但重启后的名称分配并不稳定，导致最后无法区分 sda 对应的是哪一个设备。

查找到解决方案，可绑定 UUID 到固定的 sdx。在之后的文章将记录使用 udev rule 的绑定方法，这里只记录一个快速确定 sdx 对应设备的方案。

```
udevadm info -n /dev/sdb
```

我们将得到类似下述的信息：

![](/assets/images/2023-04-14-10-38-49.png)

如果根据 VENDOR 等信息能够确定设备，那到这就足够了，否则就需要加上 `-a` 选项获得详尽的设备信息，进而判断。

又或者，你对判断哪个设备号是谁并没有兴趣，只想知道 sdb 的 USB 协议是 2.0 还是 3.0，那么类似这样的命令能够帮助你：

```
udevadm info -n /dev/sdb -a | grep version
udevadm info -n /dev/sdb -a | grep speed # 2.0 协议的速度是 480Mbps，3.0 则是 5000Mbps
```

![](/assets/images/2023-04-14-10-44-24.png)

之后的文章将总结如何将 UUID 与设备号 sdx 绑定起来。最后，感谢你阅读文章！