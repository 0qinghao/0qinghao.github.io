---
layout: post
title: SSH 密钥登录配置流程
categories: [linux]
description: 配置 linux ssh 密钥登录的过程
keywords: linux, ssh, 密钥, 登录
furigana: false
---
笔记

``` shell
ssh-keygen

cd .ssh

cat id_rsa.pub >> authorized_keys

chmod 600 authorized_keys

chmod 700 ~/.ssh

#

sudo systemctl enable ssh

sudo systemctl start ssh

# 有问题检查配置文件
sudo vim /etc/ssh/sshd_config

```

将私钥文件 id_rsa 下载到客户端机器上。

如果使用 putty 的话，打开 [PuTTYGen](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)，Import 私钥文件。

载入成功后，PuTTYGen 会显示密钥相关的信息。在 Key comment 中键入对密钥的说明信息，然后单击 Save private key 按钮即可将私钥文件存放为 PuTTY 能使用的格式。

今后，使用 PuTTY 登录时，可以在左侧的 Connection -> SSH -> Auth 中的 Private key file for authentication: 处选择私钥文件，即可登录了。
