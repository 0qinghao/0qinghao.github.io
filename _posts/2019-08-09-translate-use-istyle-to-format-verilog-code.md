---
layout: post
title: 译 - 使用 iStyle 格式化 Verilog 代码
categories: [verilog]
description: 给出 Windows x86_64 架构下编译好的 iStyle 可执行程序
keywords: verilog, iStyle, 格式化代码
furigana: false
---

> 原文：[Verilog でコード整形](https://qiita.com/kkumt93/items/70766645c07c298d19c3)

# 安装

iStyle 可以从 GitHub 上 clone、make 自行编译出可执行文件，也可以直接下载已编译好的可执行文件。这里都给出来。

**Github**

https://github.com/thomasrussellmurphy/istyle-verilog-formatter

**可执行文件**

https://github.com/0qinghao/istyle-verilog-formatter/releases/tag/v1.21_x86_64

# 格式化选项

以下是一些格式化时常用的选项及效果示例。

**待格式化代码**

``` verilog
reg [3:0] cnt;
always @(posedge clk or posedge rst) begin
if(rst) begin
cnt<=4'h0;
end else begin
cnt<=cnt+4'h1;
end
end
```

## \-\-style

**ANSI style**

``` 
./iStyle --style=ansi test.v
```

``` verilog
reg [3:0] cnt;
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        cnt<=4'h0;
    end
    else
    begin
        cnt<=cnt+4'h1;
    end
end
```

---

**Kernighan&Ritchie style**

``` 
./iStyle --style=kr test.v
```

``` verilog
reg [3:0] cnt;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt<=4'h0;
    end
    else begin
        cnt<=cnt+4'h1;
    end
end
```

---

**GNU style**

``` 
./iStyle --style=gnu test.v
```

``` verilog
reg [3:0] cnt;
always @(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        cnt<=4'h0;
      end
    else
      begin
        cnt<=cnt+4'h1;
      end
  end
```

## \-s

``` 
./iStyle -s2 test.v
```

该选项指定缩进时的空格数量，-s2 表示每次缩进使用 2 个空格（如果是 - s4 则表示每次用 4 个空格缩进）。

``` verilog
reg [3:0] cnt;
always @(posedge clk or posedge rst) begin
  if(rst) begin
    cnt<=4'h0;
  end else begin
    cnt<=cnt+4'h1;
  end
end
```

## \-p

-p 选项指定在运算符两侧插入空格。

``` verilog
reg [3: 0] cnt;
always @(posedge clk or posedge rst) begin
    if (rst)
    begin
        cnt <= 4'h0;
    end else
    begin
        cnt <= cnt + 4'h1;
    end
end
```

## \-P

-P 选项指定在运算符和括号周围插入空格。

``` verilog
reg [3: 0] cnt;
always @(posedge clk or posedge rst) begin
    if (rst)
    begin
        cnt <= 4'h0;
    end else
    begin
        cnt <= cnt + 4'h1;
    end
end
```

# 小结

虽然文中没有写，**module** 声明的缩进感觉并不是很好。verilog 有各种各样的代码风格，因此有一个强大的格式化程序是很有用的。
