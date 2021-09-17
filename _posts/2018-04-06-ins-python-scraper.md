---
layout: post
title: インスタグラム爬图
categories: [python, linux]
description: ins 自动爬图工具
keywords: ins, 爬图, python, 爬虫
furigana: false
---

repo：[https://github.com/rarcega/instagram-scraper](https://github.com/rarcega/instagram-scraper)

``` 
# https://github.com/rarcega/instagram-scraper/blob/master/setup.py
sudo python setup.py install

pip install instagram-scraper
```

``` 
instagram-scraper 用户名 -u 你的用户名 -p 你的密码 -d 存放文件夹
```

定时爬取

``` 
sudo nano /etc/crontab

*/1 * * * * Rin instagram-scraper 用户名 -d 存放文件夹

sudo /etc/init.d/cron restart
```
