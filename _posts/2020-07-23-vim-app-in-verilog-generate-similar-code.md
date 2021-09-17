---
layout: post
title: vim 在 Verilog 中的应用——生成相似代码
categories: [vim, verilog, linux]
description: 在 verilog 代码中经常出现一整段十分相似的代码，一般是只有编号不同的大段内容，比如对一整组信号做打拍时。这种时候可以应用 vim 的宏功能来快速生成代码。
keywords: vim, 宏, verilog, 生成代码
furigana: false
---

vim 作为最出色的文本编辑器之一，有着丰富的内置命令和各色各样的开源插件，可以说是杀鸡屠龙无所不能。
但同时 vim 的入门门槛高、学习曲线陡峭，也使得许多人或是望而生畏，或是浅尝辄止。当然也包括我，我在本科阶段第一次接触 vim 的时候，多半是带着一些“装x”的中二情感在强行用，直到最近才开始系统地学习、使用。目前使用的模式是在 VSCode 中激活[ vim 键映射](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim)，虽然有很多大牛选择从零将 vim 打造成完整的 IDE，但我始终认为 vim 的强处在于文本处理，IDE 部分还是交给 VSCode 吧。

回到正题，我的主要开发语言是 Verilog，在 Verilog 代码中经常会出现一整段十分相似的代码，一般是只有数字编号不同的内容。例如在对一整组信号做打拍时，这种时候可以应用 vim 的宏功能来快速生成代码。

``` verilog
// s0-s15 打一拍
always @(posedge clk)
begin
    s0_d1 <= s0;
    s1_d1 <= s1;
    s2_d1 <= s2;
    s3_d1 <= s3;
    s4_d1 <= s4;
    s5_d1 <= s5;
    s6_d1 <= s6;
    s7_d1 <= s7;
    s8_d1 <= s8;
    s9_d1 <= s9;
    s10_d1 <= s10;
    s11_d1 <= s11;
    s12_d1 <= s12;
    s13_d1 <= s13;
    s14_d1 <= s14;
    s15_d1 <= s15;
end
```

## 预备知识

### vim 宏

vim 处于 normal 模式时，按 <kbd>q</kbd> <kbd>1</kbd> 将进入宏录制模式，vim 会录制此后所有操作到宏 `1` 中。当然 <kbd>1</kbd> 键可以任意替换，相应的宏也会录制到对应的键中。录制过程中再次按 <kbd>q</kbd> 将结束录制，此后可通过 <kbd>@</kbd> <kbd>1</kbd> 的方式执行录制的内容。和 vim 中其他命令一样，可以在其前加上任意数字 n 表示重复执行 n 次。

![](/assets/images/2020-07-23-12-24-21.gif)

### vim 数字自增功能

这大概是个比较冷门的功能，很少看见有人提到，但却意外地挺有用。

normal 模式下，<kbd>Ctrl</kbd>+<kbd>a</kbd> 将从当前光标处往后查找第一个数字，并且将其 +1。类似地，<kbd>Ctrl</kbd>+<kbd>x</kbd> 实现查找、-1 的功能。

![](/assets/images/2020-07-23-12-33-50.gif)

## 生成相似代码段

应用上述两个 vim 功能，即可很方便地生成前言中一组信号打拍的代码块。基本思路是写好第一行之后：复制当前行 → 粘贴 → 找到数字自增，重复这三个操作。因此录制并重复执行的内容就是上述 3 步，具体实现过程如下。

![](/assets/images/2020-07-23-13-13-18.gif)

## 小结

*   vim 宏录制
*   vim 中的数字自增 / 自减
*   找到代码中的规律，使其自动生成

最后，感谢你阅读文章。
