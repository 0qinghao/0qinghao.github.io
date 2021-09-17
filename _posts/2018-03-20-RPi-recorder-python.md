---
layout: post
title: 树莓派学习手记——使用 Python 录音
categories: [raspberrypi, python, linux]
description: 树莓派录音，用到一张 USB 声卡
keywords: 树莓派, python, 录音, USB 声卡
furigana: false
---
有的时候我们想让树莓派能够录音，以实现语音控制等功能。所以今天我们总结一下用在树莓派上使用 Python 录音的过程。

# 准备硬件

树莓派上自带的 3.5mm 接口只能作为语音输出口，**不能**接麦克风。所以我们需要另外购买 USB 声卡，某宝上 5 元左右就能买到，当然你还需要一个麦克风。总费用应该在 20 元以内。

![](/assets/images/2020-07-06-19-45-13.png)

# 检查硬件是否正常

使用 arecord -l 可以列出所有录音设备，一般输出如下：

``` shell
arecord -l
```

> List of CAPTURE Hardware Devices
>
> card 1: Device [USB Audio Device], device 0: USB Audio [USB Audio]
>
> Subdevices: 1/1
>
> Subdevice #0: subdevice #0

同样地，aplay -l 可以列出所有播放设备，输出中也能找到形如 `Device [USB Audio Device]` 的设备。

我们可以直接在命令行执行 Linux 自带的录音 / 播放命令，测试硬件是否正常：

``` nohighlight
arecord -D hw:1,0 -t wav -c 1 -r 44100 -f S16_LE test.wav
aplay -D hw:0,0 test.wav
```

`arecord` 是录音命令，其中 `hw:1,0` 表示 `card 1: Device [USB Audio Device], device 0: USB Audio [USB Audio]` 的 `card 1 , device 0` ，如果你的 USB 声卡录音设备不是 `card 1 , device 0` ，还请进行相应修改。另外，录音过程需要手动按 <kbd>CTRL</kbd> + <kbd>C</kbd> 结束。

`aplay` 是播放命令，其中 `hw:0,0` 表示树莓派**板载**音频接口，如果你把耳机插在 USB 声卡接口，还请进行相应修改，如改成 `hw:1,0` 。

**如果你发现录制的音频内没有声音，只有细微的杂音，但 `arecord -l` 和 `aplay -l` 列出的设备中确实有 USB 声卡。那么你可以尝试着把麦克风接口拔出来一些，只插进去 2/3，或许能够解决你的问题。笔者不是很明白其中的缘由，如果你有什么想法恳请留言告知。**

# 安装 pyaudio

在 Python 中执行录音命令需要 pyaudio 模块，直接用 pip 命令安装：

``` shell
pip install pyaudio
```

如果你使用 pip 命令下载速度很慢，或许 [修改 pip 源](https://0qinghao.github.io/inforest/2018/03/16/config-pip-source/) 可以帮到你。

**如果你使用了 virtualenv，一般会发现 pyaudio 安装失败。这种情况下你需要安装 APT 中的 PortAudio 开发头文件，然后安装 PyAudio：**

``` 
sudo apt-get install portaudio19-dev
pip install pyaudio
```

# 使用 Python 录音

该例程修改自官方主页例程 [PyAudio](http://people.csail.mit.edu/hubert/pyaudio/)。

``` python
import pyaudio
import wave
import os
import sys

CHUNK = 512
FORMAT = pyaudio.paInt16
CHANNELS = 1
RATE = 44100
RECORD_SECONDS = 5
WAVE_OUTPUT_FILENAME = "output.wav"

p = pyaudio.PyAudio()

stream = p.open(format=FORMAT,
                channels=CHANNELS,
                rate=RATE,
                input=True,
                frames_per_buffer=CHUNK)

print("recording...")

frames = []

for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
    data = stream.read(CHUNK)
    frames.append(data)

print("done")

stream.stop_stream()
stream.close()
p.terminate()

wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
wf.setnchannels(CHANNELS)
wf.setsampwidth(p.get_sample_size(FORMAT))
wf.setframerate(RATE)
wf.writeframes(b''.join(frames))
wf.close()
```

执行后会录制一段 5 秒的音频，输出为同目录下的 output.wav 文件。

``` shell
python3 rec.py
```

## * 隐藏错误消息

一般情况下，在树莓派上执行上述 Python 代码后，你会看到非常多的 ALSA 报错和 JACK 报错：

> ALSA lib confmisc.c:1281:(snd_func_refer) Unable to find definition 'cards.bcm2835.pcm.front.0: CARD=0'
>
> ......
>
> ......
>
> connect(2) call to /tmp/jack-1000/default/jack_0 failed (err=No such file or directory)
> attempt to connect to server failed

但你会发现其实能够正常地录音。如果你不想看到这些错误消息，可以在代码中加入下述命令隐藏错误：

``` python
os.close(sys.stderr.fileno())
```

# 小结

使用 Python 录音很简单，你还可以在 GPIO 口上接入一个按钮，修改例程，实现按下按钮自动开始录音的功能。下一步的目标是把 Python 录音和 [Cloud Speech API 语音识别](https://0qinghao.github.io/inforest/2018/03/08/google-cloud-speech-api-voice2text-python-another-way/) 结合起来。

感谢你阅读文章！
