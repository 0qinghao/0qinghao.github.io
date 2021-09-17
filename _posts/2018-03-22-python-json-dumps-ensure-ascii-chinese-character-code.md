---
layout: post
title: python json.dumps 中的 ensure_ascii 参数引起的中文编码问题
categories: [python]
description: python 中一个坑的记录
keywords: python, ensure_ascii, dumps, 中文, 编码
furigana: false
---
json.dumps 序列化时对中文默认使用的 ascii 编码，想输出真正的中文需要指定 ensure_ascii=False。

``` python
result_str = json.dumps(result, ensure_ascii = False)
```
