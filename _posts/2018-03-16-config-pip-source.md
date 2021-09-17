---
layout: post
title: 修改 pip 源
categories: [python, linux]
description: win 和 linux 下修改 pip 软件源
keywords: python, windows, linux, pip
furigana: false
---
linux 下，修改 ~/.pip/pip.conf (没有就创建一个)，内容如下：

``` nohighlight
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
 ```

windows 下，直接在 user 目录中创建一个 pip 目录，其中新建文件 pip.ini，如：C:/Users/xx/pip/pip.ini，内容如下

``` nohighlight
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```
