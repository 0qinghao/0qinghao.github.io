---
layout: post
title: 在 virtualenv 中安装 PyAudio
categories: [python, linux]
description: python 录音
keywords: python, virtualenv, pyaudio, 录音
furigana: false
---
如果你想在一个 virtualenv 中安装 PyAudio，请安装 APT 中的 PortAudio 开发头文件，然后安装 PyAudio：

``` nohighlight
sudo apt-get install portaudio19-dev
pip install --allow-unverified=pyaudio pyaudio
```
