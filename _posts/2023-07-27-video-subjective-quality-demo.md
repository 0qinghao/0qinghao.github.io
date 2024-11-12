---
layout: post
title: 一个视频主观质量对比脚本
categories: [video codec, MOS, powershell]
description: 分享一个实用脚本，同屏播放多个视频序列，用于视频主观质量对比
keywords: 平均主观分数, MOS, 主观质量
furigana: false
---

最近开发了几个提升 H265 主观质量的算法，需要做个 demo 进行展示。mentor 以前采用的方案是使用开发板，写了个简单的应用程序使其同时解码多个码流，拼接好后输出到 HDMI 接口。我有点嫌弃搭建环境太过麻烦，还需要准备串口，因此自己撸了一个 Windows 下的脚本，调用 ffmpeg 实现。整体效果不错，而且使用起来也比较方便，唯一的不足是 ffmpeg 软解速度远远比不上开发板，4 路 1080p 播放的情况下，大约只能做到 10 fps。

# 关于主观质量评价

和在实验室测试算法，用 JCTVC/JVET 标准测试序列跑一批 BD-Rate 出来不一样，在工业上测试一个监控系统时，更多地是看主观效果，即平均主观分数 (Mean Opinion Score, MOS)。简单来说就是找一群人观看多组视频，在不知道哪个视频由哪个编码器产生的情况下，对多组视频打分，以最终得分评判编码器的好坏。

各类标准文档中有描述如何进行主观质量评价，总体上都是先播 A 再播 B，或者 A B 交叉着播，我们在测试时为了增加对比性，直接找个大屏幕同时播放多个编码器产生的序列，整体测试流程走下来比较顺利。

有一点值得提一下：现在很多中高档的大屏幕会自带很多图像优化滤镜，务必在进行测试前把设置全部过一遍，确保没有打开屏幕提供的图像优化功能。

# 一个用于主观评价的脚本

前面配置码流路径的一大部分不重要，核心命令都在 ffmpeg 的复杂滤波器部分了。描述起来倒也简单，只需要把多个输入依次裁剪、缩放，然后把他们依次放在指定坐标即可。

ffplay 部分主要是给多个画面增加标注，如不需要也可简化复杂滤波器部分。


```powershell
# stream folder, stream suffix, label
# 2x2 raster
$f0 = "D:\board_demo_stream\2023_09_22_XC00_cbr\"
$f1 = "D:\board_demo_stream\2023_09_22_XC00_cbr\"
$f2 = "D:\board_demo_stream\2023_09_22_XC00_cbr\"
$f3 = "D:\run_enc\ResultRC_2023_09_27_0127 0922 df128 saomvx2 forcepart0 skip91 lx0.7 intraw6\"

$suffix0 = "PTV3.h265"
$suffix1 = "XC01.h265"
$suffix2 = "FY11.h265"
$suffix3 = "_cbr_2M.h265"

### 如果要求调整画面顺序, 只修改这部分 start ###
# Get seq name, cat string
$seq = $args[0]
$stm0 = "$f0\$seq\$suffix0"
$stm1 = "$f1\$seq\$suffix1"
$stm2 = "$f2\$seq\$suffix2"
$stm3 = "$f3\$seq\$seq$suffix3"

# Set labels
$label0 = "PTv3"
$label1 = "XC01"
$label2 = "FY11"
$label3 = "XC00 preview"

# Special configurations
$special_cfg0 = "out_range=full"
$special_cfg1 = ""
$special_cfg2 = ""
$special_cfg3 = ""

# Check if PTv3 stream exists
if (-not (Test-Path -Path $stm0 -PathType Leaf)) {
    $stm0 = $stm0 -replace "PTv3", "PTv2"
    $label0 = $label0 -replace "PTv3", "PTv2"
    $special_cfg0 = "$special_cfg0,setpts=2*PTS"
}
### 如果要求调整画面顺序, 只修改这部分 end ###

# Set play speed (=25 normal; <25 slow; >25 fast(limited by hardware))
$speed = 25

# ffmpeg / ffplay paths
$ffmpeg = "D:\Program Files (x86)\ffmpeg\bin\ffmpeg.exe"
$ffplay = "D:\Program Files (x86)\ffmpeg\bin\ffplay.exe"

# Set screen size
$sw = 1920 * 2
$sh = 1080 * 2

# Font configuration
$label_font_common_cfg = "fontfile=simhei.ttf:fontsize=$($sw/50):fontcolor=red"

# ffmpeg command
$ffmpegCommand = @"
"$ffmpeg" -i "$stm0" -i "$stm1" -i "$stm2" -i "$stm3" -filter_complex "nullsrc=size=$sw`x$sh`:rate=25[base]; [0:v]crop=1920:1080:0:0,scale=$($sw/2):$($sh/2):$special_cfg0[0:tmp]; [1:v]crop=1920:1080:0:0,scale=$($sw/2):$($sh/2):$special_cfg1[1:tmp]; [2:v]crop=1920:1080:0:0,scale=$($sw/2):$($sh/2):$special_cfg2[2:tmp]; [3:v]crop=1920:1080:0:0,scale=$($sw/2):$($sh/2):$special_cfg3[3:tmp]; [base][0:tmp]overlay=0:0[a]; [a][1:tmp]overlay=$($sw/2):0[b]; [b][2:tmp]overlay=0:$($sh/2)[c]; [c][3:tmp]overlay=$($sw/2):$($sh/2)[d]; [d]setpts=25/$speed*PTS" -f avi -c:v rawvideo -pix_fmt yuv420p -
"@

# ffplay command
$ffplayCommand = @"
"$ffplay" -vf "drawtext=$label_font_common_cfg`:text=%{frame_num}:x=(w-tw)/2:y=h-lh,drawtext=$label_font_common_cfg`:text=$label0`:x=0:y=0,drawtext=$label_font_common_cfg`:text=$label1`:x=$($sw/2):y=0,drawtext=$label_font_common_cfg`:text=$label2`:x=0:y=$($sh/2),drawtext=$label_font_common_cfg`:text=$label3`:x=$($sw/2):y=$($sh/2)" -noframedrop -left 9999 -fs -
"@

# powershell 的管道操作很难处理, 交给 cmd 去运行
$cmdCommand = "$ffmpegCommand | $ffplayCommand"
cmd /c $cmdCommand
```

# 一个展示图像差异的脚本

这个脚本可展示 2 个序列的 Y/UV 差异，是后续重新改写的，增加了简单的交互功能，发给其他同事用会更方便一点。

增加的 Y/UV 差异也是使用复杂滤波器实现的```[0:v]format=yuva420p,lut=c1=0:c2=0:c3=128,negate[v0yforcmp]```。


```powershell
#################### para part ####################
Param 
(
    $parent_f0 = "./ResultRC_2023_11_01_0000_NO_FBC", 
    $parent_f1 = "./ResultRC_2023_11_08_0444_FBC65",
    $yuv_size = "1920x1088"
)
#################### para part end ####################

function Get-Sequences {
    $seqFolders = Get-ChildItem $parent_f0 | Where-Object { $_.PSIsContainer } | Select-Object -ExpandProperty Name

    Write-Host "Available sequences:"
    for ($i = 0; $i -lt $seqFolders.Count; $i++) {
        Write-Host "$i. $($seqFolders[$i])"
    }

    $input = Read-Host "Enter the sequence number (or 'q' to quit)"

    if ($input -eq 'q') {
        exit
    }

    if ($input -ge 0 -and $input -lt $seqFolders.Count) {
        return $seqFolders[$input]
    } else {
        Write-Host "Invalid input. Please enter a valid sequence number or 'q' to quit."
        return $null
    }
}

do {
    $selectedSeq = Get-Sequences

    if ($selectedSeq -ne $null) {
        $sw = 1920 * 2
        $sh = 1080 * 2
        $speed = 25

        $label0 = "NO FBC"
        $label1 = "FBC 65 percent"
        $label2 = "Y_difference"
        $label3 = "UV_difference"

        $input0 = "-i `"$parent_f0/$selectedSeq/$selectedSeq`_cbr_2M.h265`"" 
        $input1 = "-i `"$parent_f1/$selectedSeq/$selectedSeq`_cbr_2M.h265`"" 

        $label_font_common_cfg = "fontfile=simhei.ttf:fontsize=$($sw/50):fontcolor=red"

        $cmd_ffmpeg_part = ".\ffmpeg.exe $input0 $input1 -filter_complex `"nullsrc=size=$sw`x$sh`:rate=25[base]; [0:v]scale=$($sw/2)`:$($sh/2)[0:vp]; [1:v]scale=$($sw/2)`:$($sh/2)[1:vp]; [0:v]format=yuva420p,lut=c1=0:c2=0:c3=128,negate[v0yforcmp]; [1:v]format=yuva420p,lut=c1=0:c2=0[v1yforcmp]; [v1yforcmp][v0yforcmp]overlay,scale=$($sw/2)`:$($sh/2)[2:vp]; [0:v]format=yuva420p,lut=c0=0:c3=128,negate[v0uvforcmp]; [1:v]format=yuva420p,lut=c0=0[v1uvforcmp]; [v1uvforcmp][v0uvforcmp]overlay,scale=$($sw/2)`:$($sh/2)[3:vp]; [base][0:vp]overlay=0:0[a]; [a][1:vp]overlay=$($sw/2)`:0[b]; [b][2:vp]overlay=0:$($sh/2)[c]; [c][3:vp]overlay=$($sw/2)`:$($sh/2)[d]; [d]setpts=$(25/$speed)*PTS`" -f avi -c:v rawvideo -pix_fmt yuv420p - | "

        $cmd_ffplay_part = ".\ffplay.exe -vf `"drawtext=$label_font_common_cfg`:text=%{frame_num}:x=(w-tw)/2:y=h-lh,drawtext=$label_font_common_cfg`:text=$label0`:x=0:y=0,drawtext=$label_font_common_cfg`:text=$label1`:x=$($sw/2):y=0,drawtext=$label_font_common_cfg`:text=$label2`:x=0:y=$($sh/2),drawtext=$label_font_common_cfg`:text=$label3`:x=$($sw/2):y=$($sh/2)`" -noframedrop -left 9999 -fs -"

        $cmd = $cmd_ffmpeg_part + $cmd_ffplay_part
        cmd /c $cmd
    }
} while ($true)
```