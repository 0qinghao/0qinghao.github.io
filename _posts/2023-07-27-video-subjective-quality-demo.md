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

在视频编解码领域，主观质量评价是衡量视频编码器性能的重要方法之一。与实验室环境中通过 JCTVC/JVET 标准测试序列计算 BD-Rate 不同，工业界更关注视频的主观质量，即平均主观分数 (Mean Opinion Score, MOS)。MOS 是通过让一组观察者在不知情的情况下观看并评分多组视频序列，从而评估编码器性能的指标。

标准文档中详细描述了主观质量评价的流程，通常采用 A/B 对比或交叉播放的方式。然而，为了增强对比效果，我们在测试中采用了同时播放多个编码器生成的视频序列的方法。这种方法不仅直观，而且能够更有效地展示不同编码器的性能差异。

需要注意的是，许多中高端显示设备自带图像优化滤镜，这些滤镜可能会影响主观质量评价的准确性。因此，在进行测试前，务必检查并关闭所有图像优化功能，以确保测试结果的客观性和准确性。

通过这种方式，我们能够更全面地评估视频编码器的主观质量表现，从而为算法的优化和改进提供可靠的数据支持。

# 一个用于主观评价的脚本

前面配置码流路径的一大部分不重要，核心命令都在 ffmpeg 的复杂滤波器部分了。描述起来倒也简单，只需要把多个输入依次裁剪、缩放，然后把他们依次放在指定坐标即可。

**ffmpeg 命令中的 -filter_complex 部分解释**

1. `nullsrc=size=$sw`x$sh`:rate=25[base]`:
   - 创建一个空白视频源，大小为 `$sw` x `$sh`，帧率为 25。这个空白视频源作为基础图层。

2. `[0:v]crop=1920:1080:0:0,scale=$($sw/2):$($sh/2):$special_cfg0[0:tmp]`:
   - 对第一个输入视频流进行裁剪，裁剪后的大小为 1920x1080。
   - 将裁剪后的视频流缩放到屏幕的一半大小（\$sw/2 x \$sh/2）。
   - 应用 `$special_cfg0` 中的特殊配置（如果有）。
   - 将处理后的视频流命名为 `[0:tmp]`。
   - 重复上述步骤，得到 `[1:tmp]` `[2:tmp]` `[3:tmp]`

3. `[base][0:tmp]overlay=0:0[a]`:
   - 将第一个处理后的视频流 `[0:tmp]` 叠加到基础图层 `[base]` 的左上角 (0,0) 位置。
   - 将结果命名为 `[a]`。

4. `[a][1:tmp]overlay=$($sw/2):0[b]`:
   - 将第二个处理后的视频流 `[1:tmp]` 叠加到 `[a]` 的右上角 ($sw/2,0) 位置。
   - 将结果命名为 `[b]`。

5. `[b][2:tmp]overlay=0:$($sh/2)[c]`:
   - 将第三个处理后的视频流 `[2:tmp]` 叠加到 `[b]` 的左下角 (0,$sh/2) 位置。
   - 将结果命名为 `[c]`。

6. `[c][3:tmp]overlay=$($sw/2):$($sh/2)[d]`:
   - 将第四个处理后的视频流 `[3:tmp]` 叠加到 `[c]` 的右下角 ($sw/2,$sh/2) 位置。
   - 将结果命名为 `[d]`。

7. `[d]setpts=25/$speed*PTS`:
    - 调整最终视频流的播放速度，速度由 `$speed` 参数决定。

通过这些滤镜，脚本将四个输入视频流裁剪、缩放并拼接成一个 2x2 的网格，并调整播放速度，最终生成一个合成视频流。

ffplay 部分主要是给多个画面增加标注，如不需要也可简化复杂滤波器部分。

脚本运行后的界面类似如下，可以方便地对比多个画面。

![](/assets/images/2024-12-20-15-38-00.png)

```powershell
# stream folder, stream suffix, label
# 2x2 raster
$f0 = "T:\xxxxxxx\CBR2M"
$f1 = "T:\xxxxxxx\VBRL"
$f2 = "T:\xxxxxxx\VBRM"
$f3 = "T:\xxxxxxx\VBRH"

$suffix0 = "_cbr_2M.h265"
$suffix1 = "_vbrL_2M.h265"
$suffix2 = "_vbrM_2M.h265"
$suffix3 = "_vbrH_2M.h265"

### 如果要求调整画面顺序, 只修改这部分 start ###
# Get seq name, cat string
$seq = $args[0]
$stm0 = "$f0\$seq\$seq$suffix0"
$stm1 = "$f1\$seq\$seq$suffix1"
$stm2 = "$f2\$seq\$seq$suffix2"
$stm3 = "$f3\$seq\$seq$suffix3"

# Set labels
$label0 = "cbr 2M"
$label1 = "vbrl 2M"
$label2 = "vbrm 2M"
$label3 = "vbrh 2M"

# Special configurations
$special_cfg0 = ""
$special_cfg1 = ""
$special_cfg2 = ""
$special_cfg3 = ""
# $special_cfg0 = "out_range=full"
# $special_cfg1 = "out_range=full"
# $special_cfg2 = "out_range=full"
# $special_cfg3 = "out_range=full"

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
$ffmpeg = "C:\Users\rin.lin\ffmpeg\bin\ffmpeg.exe"
$ffplay = "C:\Users\rin.lin\ffmpeg\bin\ffplay.exe"

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

**解释生成差异图像的滤镜命令**

1. `format=yuva420p`：将输入视频格式转换为 YUVA420P，这是一个包含透明度通道的 YUV 格式。
2. `lut=c1=0:c2=0:c3=128`：使用查找表 (LUT) 滤镜，将 U 和 V 分量设置为 0，透明度通道设置为 128。这样可以突出显示 Y 分量。
3. `negate`：对视频进行反相处理，使得差异更加明显。
4. `blend=all_mode=difference:all_opacity=1`：将两个视频帧进行差异混合，显示出两个视频帧之间的差异。

通过这些滤镜，脚本能够生成两个视频序列的 Y/UV 差异图像，并将其传递给 ffplay 进行显示。


![](/assets/images/2024-12-20-15-54-08.png)

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