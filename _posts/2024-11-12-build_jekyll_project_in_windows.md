---
layout: post
title: 在 Windows 上编译基于 Jekyll 的博客站
categories: [jekyll]
description: 在本地 Windows 环境构建静态网站，推送 GitHub Pages / Coding Pages 的完整指南
keywords: jekyll, github page, 静态网页, Windows 环境配置
furigana: true
---

# 在 Windows 上编译基于 Jekyll 的博客站

虽然 Jekyll 官方并未正式支持 Windows 平台，但通过以下步骤我们依然可以在 Windows 系统上成功搭建 Jekyll 环境。本教程将手把手教你从零开始配置环境到完成站点构建。

## 环境准备

### 1. 安装 Ruby 和 Devkit
访问 [RubyInstaller 下载页面](https://rubyinstaller.org/downloads/)，选择带有 Devkit 的最新版本（写博客时使用的是 3.3.7 版本）：
- 双击安装程序，**务必勾选"Add Ruby executables to your PATH"**
- 安装最后一步时，**必须勾选运行 ridk install**
- 在 ridk install 的组件选择界面，保持默认的 `1 3` 选项按回车确认

![](/assets/images/2025-02-22-18-08-19.png)

### 2. 验证 Ruby 安装
打开新的 PowerShell 窗口（重要！确保环境变量生效）：
```powershell
ruby -v   # 应显示类似 ruby 3.x.x 的版本信息
gem -v    # 应显示 RubyGems 版本号
```

## 安装 Jekyll 核心组件

### 1. 安装 Jekyll 和 Bundler
```powershell
# 按需使用
# $Env:http_proxy="http://127.0.0.1:1080"
# $Env:https_proxy="http://127.0.0.1:1080"

# 安装核心组件
gem install jekyll bundler

# 验证安装
jekyll -v  # 应显示 Jekyll 版本号
```

## 构建你的博客站

### 1. 安装依赖包
```powershell
# 切换到博客目录下
bundle install
```

### 2. 构建静态文件
```powershell
# 指定输出目录为 docs（适配 GitHub Pages）
bundle exec jekyll build --destination ./docs

# 本地实时预览（默认端口4000）
bundle exec jekyll serve
```

## 常见问题解决

### GitHub Metadata 警告处理

如果你的个人博客站包含了 github-pages 这个插件，可能会和我一样碰到 `GitHub Metadata No GitHub API authentication could be found` 这个问题，参考下述网站，配置 API key 可以解决这个问题，本文不再赘述。
[Jekyll with GitHub Pages - Fix the "GitHub Metadata No GitHub API authentication could be found" Error](https://knightcodes.com/miscellaneous/2016/09/13/fix-github-metadata-error.html)
[Error: Repository access blocked #151](https://github.com/Yikun/hub-mirror-action/issues/151)


## 部署到 GitHub Pages
1. 将构建好的 docs 目录推送到 GitHub 仓库
2. 在仓库 Settings -> Pages 中设置发布分支和目录
3. 访问 `https://<你的用户名>.github.io/<仓库名>` 查看效果

现在你已经拥有完整的本地写作环境，可以开始创作你的技术博客了！