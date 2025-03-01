---
layout: post
title: 配置 SSH 密钥访问 Git 服务器时遇到的问题
categories: [git, linux]
description: 记录如何通过 SSH 密钥配置访问 Git 服务器
keywords: git, ssh, config, OpenSSH, RSA
furigana: false
---

在配置 SSH 密钥以访问 Git 服务器时，一般只需要生成密钥并配置公钥到服务器上。但是，在一些情况下，我发现还需要进行额外的操作才能正常连接 Git 服务器。

## 旧步骤记录

1. 启动 SSH-Agent

   首先，需要在后台运行 SSH-Agent：

   ```sh
   eval $(ssh-agent -s)
   ```

2. 添加私钥

   然后，需要手动添加私钥：

   ```sh
   ssh-add ~/.ssh/fh_gerrit
   ```

3. 检查是否添加成功

   可以通过以下命令检查当前加入的密钥：

   ```sh
   ssh-add -l
   ```

## 问题分析

之前我并没有在其他教程中看到这两步，并且在 Windows 下实现这两步碰到了一些难题。终于我发现了原因：

**OpenSSH-Client 版本问题**

   在 Ubuntu 18 (包括 OpenSSH 7.6 和 7.7 版本) 上，这套配置正常运行，但在 Ubuntu 22 (进入 8.x 版本)时，会出现连接失败。

   这是因为新版 SSH 客户端默认禁用了 RSA 密钥。解决方法如下：

   - **降级 SSH 客户端**：选择使用较旧版本的 OpenSSH 客户端。（不推荐）
   - **配置 `~/.ssh/config`**：在配置文件中显式指定 RSA 算法。

## SSH 配置

在 `~/.ssh/config` 中添加以下内容：

```sh
Host git106.fullhan.com
    HostkeyAlgorithms +ssh-RSA
    PubkeyAcceptedAlgorithms +ssh-rsa
    IdentityFile ~/.ssh/fh_gerrit
```

**注意**：Windows 和 Linux 的 SSH 客户端对 `config` 文件有不同要求：

- 在 Windows 上，上述 3 行配置都需要保留。
- 在 WSL 上，`PubkeyAcceptedAlgorithms +ssh-rsa` 该行需要删除。

另外，如果你的私钥文件夹并不是默认文件名（id_rsa/id_ed25519...），你也需要在这个文件里面显式为特定的主机配置私钥文件：

```sh
Host github.com
    IdentityFile ~/.ssh/github
```

## 注意权限问题

最后，确保 SSH 私钥的权限正确：

```sh
chmod 600 ~/.ssh/fh_gerrit
```

## 结论

通过上述配置，我们可以在 Ubuntu 22 上解决 SSH 密钥无法连接 Git 服务器的问题。并且，可以使用非默认私钥文件名，在同一设备上设置多个不同的 SSH 私钥用于不同的 Git 服务器。
