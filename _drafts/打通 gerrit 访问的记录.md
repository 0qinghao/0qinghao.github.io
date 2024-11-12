---
layout: post
title: template page
categories: [cate1, cate2]
description: some word here
keywords: keyword1, keyword2
furigana: false
---

openssh-client 版本有问题，Ubuntu18的 7.7 7.6 均成功，最新的 ubuntu22 的 8.x 失败

新版 ssh 客户端默认禁用了 RSA 加密的密钥，可通过降级客户端解决，也可在 ~/.ssh/config 中显式为特定的主机配置使用 RSA 算法。需要注意的是 windows 和 linux 的 ssh 客户端可能对 config 文件有不同的要求，就我的情况来说，windows 下需要下述完整的 3 行配置，而 wsl 上不认识第二个选项 PubkeyAcceptedAlgorithms +ssh-rsa，需要将其去除。
另外，如果你的私钥文件夹并不是默认文件名（id_rsa/id_ed25519...），你也需要在这个文件里面显式为特定的主机配置私钥文件
Host git106.fullhan.com
    HostkeyAlgorithms +ssh-RSA
    PubkeyAcceptedAlgorithms +ssh-rsa
    IdentityFile ~/.ssh/fh_gerrit

ssh 私钥记得权限设为 600

需要在后台运行 ssh-agent
eval $(ssh-agent -s)

需要 ssh-add 私钥
ssh-add ~/.ssh/fh_gerrit

check:
ssh-add -l
