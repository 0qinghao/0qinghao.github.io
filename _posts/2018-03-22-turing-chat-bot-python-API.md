---
layout: post
title: 使用 Python 与图灵机器人聊天
categories: [python]
description: 图灵机器人 API 使用例
keywords: 图灵机器人, python
furigana: false
---
图灵机器人对中文的识别准确率高达 90%，是目前中文语境下智能度最高的机器人。有很多在 Python 中使用图灵机器人 API 的博客，但都是 1.0 版本。所以今天简单地总结一下在 Python 中使用图灵机器人 API v2.0 的方法。

# 获取 API KEY

首先，前往图灵机器人官方网站 http://www.tuling123.com/ 注册账号。

登录后点击 ` 创建机器人 ` ，填写一些简单的基本信息之后即可创建。

![](/assets/images/2020-07-06-19-46-01.png)

在机器人设置界面找到你的 `API KEY` ，记录下来。

![](/assets/images/2020-07-06-19-46-09.png)

# 在 Python 中使用图灵机器人 API v2.0

基本原理就是使用 urllib.request 模块，向接口地址发送 HTTP POST 请求，请求中加入了聊天内容。

***使用 python3 执行**

``` python
import json
import urllib.request

api_url = "http://openapi.tuling123.com/openapi/api/v2"
text_input = input('我：')

req = {
	"perception":
	{
		"inputText":
		{
			"text": text_input
		},

		"selfInfo":
		{
			"location":
			{
				"city": "上海",
				"province": "上海",
				"street": "文汇路"
			}
		}
	},

	"userInfo":
	{
		"apiKey": "请替换为你的 API KEY",
		"userId": "OnlyUseAlphabet"
	}
}
# print(req)
# 将字典格式的 req 编码为 utf8
req = json.dumps(req).encode('utf8')
# print(req)

http_post = urllib.request.Request(api_url, data=req, headers={'content-type': 'application/json'})
response = urllib.request.urlopen(http_post)
response_str = response.read().decode('utf8')
# print(response_str)
response_dic = json.loads(response_str)
# print(response_dic)

intent_code = response_dic['intent']['code']
results_text = response_dic['results'][0]['values']['text']
print('Turing 的回答：')
print('code：' + str(intent_code))
print('text：' + results_text)
```

![](/assets/images/2020-07-06-19-46-20.png)

**几点说明：**

1、字典 `req` 包含了向图灵机器人发出请求所需的各项信息。其中 `req['perception']['selfInfo']['location']` 包含了地理位置信息，向图灵机器人发送与位置有关的请求时，如果没有另外指定位置，则会默认使用这个位置。例如询问 "明天会下雨吗"，图灵机器人会回答我 "上海" 明天是否下雨。

2、 `req['userInfo'] ` 包含了 API KEY，请替换成你的 API KEY（双引号不要删除）。另外 `userId` 是用户参数，暂时不明白用途，如果你有什么想法恳请留言。

3、图灵机器人的回答可以转换为 python 的字典格式。其中有一项 `response_dic['intent']['code']` 官方称为 "输出功能 code"，表示这个回答是什么 "类型" 的。例如 10004 代表普通的聊天回复，10008 代表与天气相关的回复。然而奇怪的是，目前 API v2.0 的官方文档并没有给出 code 和类型的对照表。目前自己总结了一些如下，欢迎补充：

| code | 类型                                         |
| :---: | -------------------------------------------- |
| 10004 | 聊天                                         |
| 10008 | 天气                                         |
| 10013 | 科普类，例如 "班戟是什么"                     |
| 10015 | 菜谱类，例如 "剁椒鱼头怎么做"                 |
| 10019 | 日期类，例如 "愚人节是几号"、"明天是星期几"   |
| 10020 | 中英翻译                                     |
| 10023 | 一般返回网页会是这个 code，例如 "iphone 多少钱" |
| 10034 | 语料库中自己设定的回答                       |

# 小结

到现在为止，已经快把每个独立的模块完成了，接下来该准备考虑如何把它们整合在一起了。希望能帮到你。

感谢你阅读文章！
