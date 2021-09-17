---
layout: post
title: 在基于 Jekyll 的博客中加入文字的注音
categories: [日语, linux]
description: 在使用 jekyll 构建的博客文章中加入注音, 同时涉及本地构建静态网站推送 github page / coding page 的方法
keywords: jekyll, 注音, ruby, 振假名, hurigana, furigana, 日语, 日文, github page, 静态网页
furigana: true
---

越来越多的人选择将博客托管在 [GitHub page](https://pages.github.com/) 或是国内的 [Coding page](https://help.coding.net/docs/devops/cd/static-website.html)，通过 Jekyll 将 markdown 排版的文章渲染为静态网页。
当一个 repo 被你设定为 GitHub page 时，GitHub 将检测 repo 的目录结构，如果符合 Jekyll 的特征，例如根目录下包含 `_config.yml` 配置时，GitHub 将在你 push 后自动进行在线构建。

![](/assets/images/2020-07-23-20-40-26.png)

查看 repo 的提交历史将能看到构建成功的消息，如果构建失败则会收到一封邮件报告。因此理论上我们在本地甚至不需要配置 Jekyll 环境，只需要保证 push 的内容具备让 GitHub 进行在线构建的条件即可。

### 在线构建的局限性

将构建的任务交给 GitHub 确实十分方便，也能满足绝大部分用户的需求。但我们注意到 GitHub 提供的在线构建服务并不支持所有 Jekyll 插件，支持列表可以在这里查询：[https://pages.github.com/versions/](https://pages.github.com/versions/)

而很不幸的是，有一个插件对我来说是必不可少的，而它却不在支持列表中。这个插件是 [jekyll-furigana](https://github.com/guentoan/jekyll-furigana)，用于给文本注音，主要应用场景有：

( 日本語:にほんご )の( 漢字:かんじ )に( 振:ふ )り( 仮名:がな )を( 編集:へんしゅう )する

( 中:zhōng )( 文:wén )拼音注音

( 奇奇怪怪的用法:😀😁🤣😑🤨😮😶 )
 
幸运的是 GitHub page 支持关闭在线构建，代价则是用户必须在本地配置好 Jekyll 环境，构建、推送构建完成的静态网页到 GitHub page repo。

> [GitHub Pages cannot build sites using unsupported plugins. If you want to use unsupported plugins, generate your site locally and then push your site's static files to GitHub.](https://docs.github.com/en/github/working-with-github-pages/about-github-pages-and-jekyll#plugins)

### 配置 jekyll-furigana 插件

配置 Jekyll 插件的前提当然是配置好本地 Jekyll 环境。这里默认大家已经配置好了，如果还没配置的可以跟着[官方文档](http://jekyllcn.com/docs/installation/)做，这里只描述插件的配置方法。

1. 在 Gemfile 中配置 jekyll-furigana 插件
    ``` shell
    source 'https://rubygems.org'
    gem 'github-pages', group: :jekyll_plugins
    gem 'tzinfo-data'
    gem 'jekyll-furigana', group: :jekyll_plugins
    ```

2. 安装
    ``` shell
    $ bundle
    ```

3. 在 Jekyll 配置文件 `_config.yml` 中的 `plugins:` 部分配置插件
    ``` shell
    plugins:
        - jekyll-github-metadata
        - rouge
        - jekyll-paginate
        - jekyll-sitemap
        - jekyll-feed
        - jemoji
        - jekyll-furigana
    ```

4. 在需要启用注音功能的 markdown 博客文件头中加入 `furigana: true`
    ``` markdown
    ---
    layout: post
    title: 在基于 Jekyll 的博客中加入文字的注音
    categories: [日语]
    furigana: true
    ---
    ```

5. 修改 `_layouts/post.html` 中的 `content` 过滤器，加入 `furigana` 过滤器
    ![](/assets/images/2020-07-24-20-20-27.png)
    *   默认情况下是修改 `post.html` 文件，如果你的 markdown 文件头中的 `layout` 属性不是 `post` 那就要去修改对应的文件。

### 使用方法

jekyll-furigana 插件有多种使用格式，可选用下面任意一种。

![](/assets/images/2020-07-24-20-23-07.png)

他们在启用了插件的页面上，都将被渲染为：

(日本語:にほんご)

### 编译静态网页推送到 GitHub page repo

在根目录下编译静态网页，输出到 `./docs`
```shell
jekyll build --destination ./docs
```
将 `docs` 文件夹内的内容推送到 GitHub page repo
```shell
cd ./docs

git init

git add -A

git commit -m "test furigana"

git remote add origin https://your-repo-url.git

git push origin master
```
大约 2 分钟之后，即可打开网页检查插件是否生效。

最后，感谢你阅读文章。