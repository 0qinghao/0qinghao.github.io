---
layout: post
title: python - 创建 virtualenv 时选择继承系统站点程序包
categories: [python, linux]
description: python 创建虚拟环境时继承系统程序包
keywords: python, virtualenv, 继承
furigana: false
---
笔记

``` nohighlight
virtualenv --system-site-packages --python python3 env
```

可以解决 smbus 模块不存在的问题。
