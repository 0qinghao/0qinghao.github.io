---
layout: page
title: 日语专栏
description: 日更自己每天学习的一个日语单词( 雾 ), 更新频繁, 内容不多不适合放主页, 单独开一个页面放置
keywords: 日语
comments: true
menu: 日语
permalink: /ja_page/
---

<section class="container posts-content">
{% assign count = 1 %}
{% for ja_page in site.ja_page %}

    {% assign year = ja_page.date | date: '%Y' %}
    {% assign nyear = ja_page.next.date | date: '%Y' %}
    {% if year != nyear %}
        {% assign count = count | append: ', ' %}
        {% assign counts = counts | append: count %}
        {% assign count = 1 %}
    {% else %}
        {% assign count = count | plus: 1 %}
    {% endif %}

{% endfor %}

{% assign counts = counts | split: ', ' | reverse %}
{% assign i = 0 %}

{% assign thisyear = 1 %}

{% for ja_page in site.ja_page reversed %}

    {% assign year = ja_page.date | date: '%Y' %}
    {% assign nyear = ja_page.next.date | date: '%Y' %}
    {% if year != nyear %}
        {% if thisyear != 1 %}
            </ol>
        {% endif %}

        <h3>{{ ja_page.date | date: '%Y' }} ({{ counts[i] }})</h3>
        <!-- <h3>{{ ja_page.date | date: '%Y' }}</h3> -->

        {% if thisyear != 0 %}
            {% assign thisyear = 0 %}
        {% endif %}
        <ol class="posts-list">
        {% assign i = i | plus: 1 %}
    {% endif %}

    <li class="posts-list-item">
    <span class="posts-list-meta">{{ ja_page.date | date:"%m-%d" }}</span>
    <a class="posts-list-name" href="{{ site.url }}{{ ja_page.url }}">{{ ja_page.title }}</a>
    </li>

{% endfor %}
</ol>
</section>
