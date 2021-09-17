---
layout: post
title: 配置澎峰 Perf-V 开发板 RISC-V 开发环境
categories: [risc-v, linux]
description: RISC-V 小开发板的环境配置, 研究生后写的博客
keywords: RISC-V
furigana: false
---
实验室买了一块 Perf-V 开发板，准备开始做 RISC-V 相关的工作。

虽然澎峰直接给了配置好的虚拟机开发环境，不过因为 Ubuntu16.03 用着不顺手就想要自己把环境配出来。

看澎峰给的 SDK 目录，就是直接用的开源蜂鸟（GitHub：e200_opensource）微调来的。所以最初尝试着 git e200_opensource 重新配置一遍，结果失败，报错找不到'cc1'。尝试添加 PATH 等操作无果。

> riscv-none-embed-gcc: error trying to exec 'cc1': execvp: No such file or directory

后尝试直接把给的环境升级到 18.04，结果出现与上述相同的问题。

那行吧，既然 sirv-e-sdk 和 Perf-V-e-sdk 都是从 SIFIVE 的 freedom-e-sdk（GitHub：freedom-e-sdk）精简来的，那我就配置整个 freedom-e-sdk 吧。

总之这几天为了搞定 Perf-V 开发板的开发环境，前前后后踩了不少坑。现在把最后结果记录如下，备忘。

# 克隆 freedom-e-sdk 存储库

``` sh
git clone --recursive https://github.com/sifive/freedom-e-sdk.git
```

文件大，耗时比较长。

# 从源代码构建 Tools

Ubuntu 需要这些 packages：

``` sh
sudo apt-get install autoconf automake libmpc-dev libmpfr-dev libgmp-dev gawk bison flex texinfo libtool libusb-1.0-0-dev make g++ pkg-config libexpat1-dev zlib1g-dev
```

build：

``` 
cd freedom-e-sdk
make tools [BOARD=freedom-e300-hifive1]
```

build 过程耗时很长。

# 替换板级支持包

freedom-e-sdk 是 SIFIVE 的开发环境，里面的板级支持包只有 sifive 系列，要用来开发 Perf-V 需要先替换 bsp 文件夹。

``` 
mv ./bsp ./bsp_bak
cp -r ~/fengniao/e200_opensource/Perf-V-e-sdk/bsp ./
```

可以把 Perf-V 开发板自带的几个程序顺便复制过来，方便之后测试。

``` 
mv ./software ./software_bak
cp -r ~/fengniao/e200_opensource/Perf-V-e-sdk/software ./
```

# PC 和开发板的连接

如果手头上有胡振波大大《RISC-V 处理器》这本书的同学，请翻到 P318，18.3 节提到了他们的开发板是怎么配置和 PC 连接的。基本上照做就行了，可是别忘了，他们的开发板是 Arty，虽然澎峰用的也是 A7，但是板子 ID 可不一样，所以有 2 个参数要注意了。

我这就照着书上的步骤 2 到 6 简单写一下。

**步骤二：通电；点 USB 图标连接至虚拟机**

**步骤三：使用如下命令查看 USB 状态**

``` 
lsusb
```

> Bus 001 Device 002: ID 0403:6010 Future Technology Devices International, Ltd FT2232C Dual USB-UART/FIFO IC

记下 0403:6010 这两个数。

**步骤四：设置 udev rules，使 USB 能够被 plugdev group 访问**

``` 
sudo nano /etc/udev/rules.d/99-openocd.rules
```

``` 
# 写入以下内容，注意 0403 和 6010，和书上不一样
SUBSYSTEM=="usb", ATTR{idVendor}=="0403",
ATTR{idProduct}=="6010", MODE="664", GROUP="plugdev"
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403",
ATTRS{idProduct}=="6010", MODE="664", GROUP="plugdev"
```

**步骤五：看看 USB 设备所属组，略**

**步骤六：把自己的用户添加到组中**

``` 
sudo usermod -a -G plugdev 你的用户名
```

# 编译上传裸机 RISC-V 程序

``` 
cd freedom-e-sdk
make software PROGRAM=demo_gpio BOARD=Perf-V-creative-board
make upload PROGRAM=demo_gpio BOARD=Perf-V-creative-board
```
