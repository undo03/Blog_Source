---
title: css 布局技巧
subtitle: css_layout_skills
tags: [CSS, 布局技巧]
date: 2017-07-23
categories: JavaScript
description:
---

在写`HTML`页面的时候难免会遇到一些奇奇怪怪的现象，合理使用 `Css` 的属性就能达到我们想要的样式效果。

这篇文章目的在于记录开发中遇到的比较常见但又有些小窍门的一些布局技巧。

<!--more-->

### 1. 父设置了`overflow: hidden`子如何不受影响

```javascript
<div style="width: 200px;height: 200px;padding:30px;margin: 30px auto;border: 1px solid #000;overflow: hidden;">
    <div style="width: 300px;height: 300px;background: #df3434;"></div>
</div>
```

给子元素一个`position: absolute;`定位即可

```javascript
<div style="width: 200px;height: 200px;padding:30px;margin: 30px auto;border: 1px solid #000;overflow: hidden;">
    <div style="position:absolute;width: 300px;height: 300px;background: #df3434;"></div>
</div>
```
