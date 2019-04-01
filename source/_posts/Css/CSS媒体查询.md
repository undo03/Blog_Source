---
title: CSS - 媒体查询@media
subtitle: css_media
tags: [CSS, 媒体查询, media]
date: 2019-3-31
categories: CSS
description:
---

记录一次小需求引发的对媒体查询的学习。

最近接到一个小需求，只做页面重构，本着切图的想法就准备开工了，打开设计给出的设计稿，发现里面有1366px 和 1920px 宽度的两份设计稿和切图，第一想法是按照某一个尺寸来做，经过跟产品和设计确认，是要求适配这两个尺寸。由于之前做这种适配性的页面经验较少，所以刚开始是有点懵的，有点不知所措。

经过分析，其实就是两种尺寸下，各个元素的大小、字体、间距等的尺寸不同，那么想到的就是在不同的屏幕尺寸下用不同的布局尺寸，自然就想到了媒体查询。
<!--more-->

### 解决方案

根据媒体查询，获得浏览器的宽度，根据宽度加载对应的css，具体的实现方式有下面几种：
1.直接在CSS中使用
```css
@media screen and (max-width: 1919px) {  
	// CSS样式
}
  
@media screen and (min-width: 1920px) {  
	// CSS样式
}
```

2.在@import中引入
```html
<style type="text/css" media="screen and (max-width:1919px)">
	@import url("../css/index1366.css");
</style>
<style type="text/css" media="screen and (max-width:1920px)">
	@import url("../css/index1920.css");
</style>
```

3.在head中动态引入
```html
<link media="screen and (max-width: 1919px)" rel="stylesheet" href="../css/index1366.css">
<link media="screen and (min-width: 1920px)" rel="stylesheet" href="../css/index1920.css">  
```

在最终选择是第三种方案，这种方案更适合本次的需求，把相同的代码写在公用的文件中，差异的css代码，分别写在对应的css文件中，这样方便管理和修改。第二种方式和第三种其实是一样的但是多用一个 style 标签，第一种是将代码合在一起虽然只管，但是显得比较混乱，不方便分离和管理。

### 媒体查询学习

**媒体查询**，添加自CSS3，允许内容的呈现针对一个特定范围的输出设备而进行裁剪，而不必改变内容本身。媒体查询包含一个可选的[媒体类型](https://developer.mozilla.org/en-US/docs/CSS/@media)和媒体特性表达式(0或多个)最终会被解析为`true`或`false`。如果媒体查询中指定的媒体类型匹配展示文档所使用的设备类型，并且所有的表达式的值都是`true`，那么该媒体查询的结果为`true`。

当媒体查询未`true`时，对应的样式就会进行应用。使用 `<link>` 标签指向的样式表，即使媒体查询为`false`也会下载但是不会被应用。
```
@media 媒体类型 逻辑操作符 媒体特征
```


#### 媒体类型

让我们先了解一下媒体类型，这个大家会比较熟悉一点，我们通常会用到的类型会是`all` 和`screen`，然后是`print`，一些网站会专门通过`print`类型为页面的打印格式提供更友好的界面。其实，`media type`有很多种：

| 类型       | 解释                                     |
| ---------- | ---------------------------------------- |
| all        | 所有设备                                 |
| braille    | 盲文                                     |
| embossed   | 盲文打印                                 |
| handheld   | 手持设备                                 |
| print      | 文档打印或打印预览模式                   |
| projection | 项目演示，比如幻灯                       |
| screen     | 彩色电脑屏幕                             |
| speech     | 演讲                                     |
| tty        | 固定字母间距的网格的媒体，比如电传打字机 |
| tv         | 电视                                     |



#### 逻辑操作符

逻辑操作符包括`not`、`and`和`only`等，构建复杂的媒体查询。`and`操作符用来把多个媒体属性组合成一条媒体查询，对成链式的特征进行请求，只有当每个属性都为真时，结果才为真。`not`操作符用来对一条媒体查询的结果进行取反。`only`操作符仅在媒体查询匹配成功的情况下被用于应用一个样式，这对于防止让选中的样式在老式浏览器中被应用到。若使用了`not`或`only`操作符，必须明确指定一个媒体类型。

**and**
`and`关键字用于合并多个媒体属性或合并媒体属性与媒体类型。
```css
@media screen and (min-width: 700px) and (max-width: 1919px) { ... }
 ```
表示在电脑屏幕跨宽度在700-1910之间的时候应用的css样式。

**not**
`not` 关键字应用于整个媒体查询，在媒体查询为假时返回真 (比如 `monochrome` 应用于彩色显示设备上或一个600像素的屏幕应用于 `min-width: 700px` 属性查询上 )。在逗号媒体查询列表中`not`仅会否定它应用到的媒体查询上而不影响其它的媒体查询。 `not`关键字仅能应用于整个查询，而不能单独应用于一个独立的查询。
```css
@media not all and (monochrome) { ... }
```
等价于：
```css
@media not (all and (monochrome)) { ... }
```
而不是
```css
@media (not all) and (monochrome) { ... }
```

**only**
`only`关键字防止老旧的浏览器不支持带媒体属性的查询而应用到给定的样式：
```html
<link rel="stylesheet" media="only screen and (color)" href="example.css" />
```

**逗号分隔列表**
媒体查询中使用逗号分隔效果等同于`or`逻辑操作符。当使用逗号分隔的媒体查询时，如果任何一个媒体查询返回真，样式就是有效的。逗号分隔的列表中每个查询都是独立的，一个查询中的操作符并不影响其它的媒体查询。这意味着逗号媒体查询列表能够作用于不同的媒体属性、类型和状态。
```css
@media (min-width: 700px), handheld and (orientation: landscape) { ... }
```
表示在最小宽度为700像素或是横屏的手持设备上应用一组样式。

#### 媒体特征

大多数媒体属性可以带有“min-”或“max-”前缀，用于表达“最低...”或者“最高...”。例如，`max-width:12450px`表示应用其所包含样式的条件最高是宽度为12450px，大于12450px则不满足条件，不会应用此样式。这避免了使用与HTML和XML冲突的“<”和“>”字符。如果你未向媒体属性指定一个值，并且该特性的实际值不为零，则该表达式被解析为真。
常用的媒体特征有：

| 属性                | 值                     | Min/Max | 描述                     |
| ------------------- | ---------------------- | ------- | ------------------------ |
| color               | 整数                   | yes     | 每种色彩的字节数         |
| color-index         | 整数                   | yes     | 色彩表中的色彩数         |
| device-aspect-ratio | 整数/整数              | yes     | 宽高比例                 |
| device-height       | length                 | yes     | 设备屏幕的输出高度       |
| device-width        | length                 | yes     | 设备屏幕的输出宽度       |
| grid                | 整数                   | no      | 是否是基于格栅的设备     |
| height              | length                 | yes     | 渲染界面的高度           |
| monochrome          | 整数                   | yes     | 单色帧缓冲器中每像素字节 |
| resolution          | 分辨率(“dpi/dpcm”)     | yes     | 分辨率                   |
| scan                | Progressive interlaced | no      | tv媒体类型的扫描方式     |
| width               | length                 | yes     | 渲染界面的宽度           |
| orientation         | Portrait/landscape     | no      | 横屏或竖屏               |

**max与min**

| height              | min-height              | max-height              |
| ------------------- | ----------------------- | ----------------------- |
| device-width        | min-device-width        | max-device-width        |
| device-height       | min-device-height       | max-device-height       |
| aspect-ratio        | min-aspect-ratio        | max-aspect-ratio        |
| device-aspect-ratio | min-device-aspect-ratio | max-device-aspect-ratio |
| color               | min-color               | max-color               |
| color-index         | min-color-index         | max-color-index         |
| Monochrome          | min-monochrome          | max-monochrome          |
| Resolution          | min-resolution          | max-resolution          |

**媒体查询浏览器支持度：**

- IE 9以下不支持
- Firefox 3.5+(Gecko 1.9.1+)支持
- Opera 9.5+完全支持
- Opera mini 5支持
- webkit 支持大部分属性(`safari` 3.0的内核版本是522，iPhone 1代的`safari`的内核版本是524，`webkit`大概从这个时候开始支持`media query`，但是对部分属性比如`projection`支持不好)
- iPhone OS 3.2之前的版本不支持`orientation`属性，iPad和iPhone 4支持该属性。
- iPhone Safari不支持`orientation`(iPhone 4支持)

### 总结

CSS3的media query是一个很强大也很好用的工具，它为我们在不同的设备和环境下实现丰富的界面提供了一种快捷方法，虽然现在各个浏览器对它的支持还有些差异，但是大家都在改进，IE 9已经开始支持media query了。不过目前media query的最大舞台是在高端手持设备，相信随着移动互联网的快速发展，media query也会很好发挥自己的作用。

**相关链接：**
[【CSS媒体查询】](https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Media_queries)
[【@media】](https://developer.mozilla.org/en-US/docs/Web/CSS/@media)