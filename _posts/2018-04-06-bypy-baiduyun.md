---
layout: post
title: 使用 bypy 在命令行上传文件到百度云盘
categories: [linux]
description: 命令行百度网盘
keywords: 百度云, 百度网盘, 命令行
furigana: false
---

repo: [https://github.com/houtianze/bypy](https://github.com/houtianze/bypy)

**安装**

``` 
pip install bypy

# 执行任意命令进行授权
bypy info
```

``` 
#上传文件夹内的内容到 app/bypy/
bypy upload 文件夹
```

``` 
#定时执行上传
sudo nano /etc/crontab

*/1 * * * * Rin bypy upload 文件夹

sudo /etc/init.d/cron restart
```
