---
layout: post
title: 使用谷歌 Cloud Speech API 将语音转换为文字
categories: [google cloud, STT]
description: 谷歌云语音转文字 API 的使用
keywords: google cloud, 语音转文字, STT, Speech API
furigana: true
---
[Google Cloud Speech API](https://cloud.google.com/speech/) 是由谷歌云平台提供的，利用机器学习技术将语音转换为文字的服务。这个 API 能识别超过 80 种语言和语言变体，包括中文、日语、英语甚至广东话。这次，我总结了使用 Google Cloud Speech API 的基本流程。

# 花 5 秒钟试用 Cloud Speech API 吧

在 [Cloud Speech API 概览页](https://cloud.google.com/speech/)，我们可以体验将语音转换为文字的效果。只需要选择一种语言即可开始使用，甚至不需要登录谷歌账号。（加载出来需要一些时间）

![](/assets/images/2020-07-06-19-40-10.png)

# 在项目中添加 API

使用 Cloud Speech API 需要登录谷歌云平台并申请免费试用，申请试用谷歌云平台的流程可以参考 [这篇文章](https://0qinghao.github.io/inforest/2018/02/27/google-cloud-engine-ss-server/) 。

我们假定你能够使用谷歌云平台，并且已经创建了一个项目，下面介绍如何把 Cloud Speech API 添加到项目中。

点击 [控制台](https://console.cloud.google.com/) 左上角的 `☰` 打开导航栏，找到 `API 和服务 ` → ` 库 ` 。

![](/assets/images/2020-07-06-19-40-18.png)

在搜索框中键入 `Speech` 即可找到 `Cloud Speech API` 。

![](/assets/images/2020-07-06-19-40-25.png)

打开 API 页面，点击 ` 启用 ` 。

# 创建 API 密钥

回到之前的页面，选择 ` 凭据 ` → ` 创建凭据 ` → `API 密钥 ` 。

![](/assets/images/2020-07-06-19-40-31.png)

马上 `API 密钥` 就创建好了，虽然随时都能在这个页面查询，但为了方便起见，将其记录下来备用吧，很快就要用到它。

` 限制密钥 ` 选项默认情况下应该是 “无”，这次只是试着使用 API，保持默认“无” 即可。

# 准备声音文件

虽然有些麻烦，但是接下来我们要准备声音文件。Cloud Speech API 没办法直接识别 mp3、mp4 中的声音，我们需要准备 FLAC、WAV 格式的音频。而且**仅支持单声道音频**，所以一般都需要转码之类的工作。

详细的声音文件要求参见：[AudioEncoding - Google Cloud Speech API](https://cloud.google.com/speech/reference/rest/v1/RecognitionConfig#AudioEncoding)

基于上述情况，我读了下面这段文稿，并制成了 FLAC 格式（单声道）的声音文件。是用手机麦克风进行录音的，质量一般 (´ ・ω・｀) 是否可以正确识别呢？

[voice.flac](https://share.weiyun.com/b426055608aa3b2c4d5adfda1fb5d67f)

> 寄蜉蝣于天地，渺沧海之一粟。哀吾生之须臾，羡长江之无穷。挟飞仙以遨游，抱明月而长终。
>
>
> [《赤壁赋》](http://www.millionbook.com/gd/s/shushi/000/001.htm)

# 将声音文件上传到 Cloud Storage

如果要使用 Cloud Speech API 识别本地声音文件，必须将音频文件编码为 base64，然后嵌入到稍后将创建的 json 请求文件中，这虽然可行但并不方便。如果你想使用这种方法，请参考：[Embedding Base64 encoded audio - Google Cloud Speech API](https://cloud.google.com/speech/docs/base64-encoding#embedding_base64_encoded_audio)

我们将使用另一种方案，将声音文件上传到 Google Cloud Storage。

点击控制台左上角的 `☰` 打开导航栏，找到 ` 存储 ` → ` 浏览器 ` 。

![](/assets/images/2020-07-06-19-40-38.png)

点击 ` 创建存储分区 ` 。

输入合适的**` 存储分区名称 `**，后文将要用到。默认存储类别选择 "Multi-Regional"，Multi-Regional 位置选择 "亚洲"。点击 ` 创建 ` 。

![](/assets/images/2020-07-06-19-40-44.png)

点击 ` 上传文件 ` ，上传声音文件，勾选 ` 公开链接 ` 。**（该音频将能被任何人访问，请注意）**

> 2018 年 10 月 18 日更新：
> 刚看了一下，页面有所改变，暂时没找到公开单个音频文件的方法。
> 你可以这样做，把整个存储分区公开：
> 导航栏→存储→浏览器→存储分区最后有个选项，点开来→修改存储分区权限→“添加成员”填 “allUsers”，“角色” 选“存储对象查看者”→添加
> 注意：这样该分区内所有内容都可能被任何人访问到

另外，请记住上传文件的**` 文件名 `**，后文将用到。

![](/assets/images/2020-07-06-19-41-28.png)

# 将语音转换为文字

终于，可以使用 Cloud Speech API 将语音转换为文字了。

首先，我们新建一个 json 格式的请求文件（request.json）。文件名无特殊要求。

``` json
{
  "config":
  {
    "encoding":"FLAC",
    "languageCode":"cmn-Hans-CN"
  },

  "audio":
  {
    "uri":"gs:// 存储分区名称 / 文件名"
  }
}
```

注意 3 个地方：

**`cmn-Hans-CN`**：表示识别语言为中文普通话。常用的还有 American English ( `en-US` )、British English ( `en-GB` )、日本語 ( `ja-JP` )、廣東話( `yue-Hant-HK` )。更多语言支持可以在[Language Support - Google Cloud Speech API](https://cloud.google.com/speech/docs/languages) 查询。

**` 存储分区名称 `**：刚才是否有记录下来呢？如果没有记住可以点击控制台左上角的 `☰` 打开导航栏，找到 ` 存储 ` → ` 浏览器 ` 查看。

**` 文件名 `**：存储在 Cloud Storage 中的音频文件名，可以在存储分区中查看。

最后，我们使用 curl 命令（Windows 平台需另外 [安装](https://curl.haxx.se/download.html)）向 Cloud Speech API 发出请求。

cd 到 json 请求文件所在目录。

> curl -H "Content-Type: application/json" -d @**`request.json`**"https://speech.googleapis.com/v1/speech:recognize?key=**`API 密钥 `**"

注意 2 个加粗处：

**`request.json`**：json 请求文件的文件名。

**`API 密钥 `**：替换为你记录下来的 API 密钥。如果没有记下来，可以点击控制台左上角的 `☰` 打开导航栏，找到 `API 和服务 ` → ` 凭据 ` 查看。

得到结果：

![](/assets/images/2020-07-06-19-41-40.png)

可以看到返回结果也是 json 格式的数据。"confidence" 是置信度，越接近 1 准确性越高。

# 小结

第一次尝试语音识别服务，得到结果的时候很开心。或许有人会惊讶上例语音识别的准确性，但正如文章开头所说 “Cloud Speech API 是利用**机器学习**技术将语音转换为文字的服务”，像上例中这样的俗语、名著甚至是歌词，准确率都出奇地高。如果你录制一段日常语音交给 Cloud Speech API 识别，结果就不那么满意了。

最后，这次只是使用 curl 命令在 LX 终端获得了识别结果，下次将会总结如何在编程语言中使用 Cloud Speech API。

感谢你阅读文章！
