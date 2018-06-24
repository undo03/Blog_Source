---
title: NexT 主题配置
subtitle: hexo next
tags: [hexo,主题配置]
date: 2018-06-11
categories: Periphery
---
NexT 拥有丰富而简单的配置，结合第三方服务，打造属于您自己的博客.NexT 坚持将复杂的细节隐藏，提供尽量少并且简便的设置，保持最大限度的易用性。除了 Markdown 支持的语法之外，NexT 借助 Hexo 提供的标签特性， 为您提供在书写文档时快速插入带特殊样式的内容。使用 第三方服务 来扩展站点的功能， NexT 支持多种常见第三方服务。

<!--more-->

### 1.统计文章阅读次数

#### 1.1 到 [leancloud.cn](https://leancloud.cn/) 注册账号，创建应用，

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/1529573803947.jpg?raw=true)

#### 1.2 在数据模块中 创建Class，名称一般为 Counter

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/WX20180621-175120.png?raw=true)

#### 1.3 在设置中拿到该应用的 App ID 、 App Key

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/WX20180621-175238.png?raw=true)

#### 1.4 设置安全域名，只有在允许的域名下才会进行正常的统计

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/WX20180621-175623.png?raw=true)

#### 1.5 在主题的_config.yml中进行配置

```javascript
leancloud_visitors:
	enable: true
	app_id: TrNg*****************Hsz #<app_id>
	app_key: xPUp****************wAk #<app_key>
```

#### 1.6 重新部署，然后访问，然后去 [leancloud.cn](https://leancloud.cn/) 查看记录

```javascript
hexo clean
hexo g
hexo s
```

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/WX20180621-175319.png?raw=true)

然后在文章中就可以看到阅读次数了

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/WX20180621-184902.png?raw=true)

### 2.集成评论 gitment

next主题在v5.1.2以上版本已经将gitment集成进去了，开启gitment只需要做以下操作

#### 2.1 注册OAuth Application

点击[https://github.com/settings/applications/new](https://github.com/settings/applications/new)注册，注意Authorization callback URL填自己的网站url [http://songqibin.cn/](http://songqibin.cn/).记下Client ID和Client Secret.

#### 2.2 修改themes/next/_config.yml

```javascript
gitment:
  enable: true
  mint: true 
  count: true 
  lazy: false 
  cleanly: true 
  language: 
  github_user: undo03 # MUST HAVE, Your Github ID
  github_repo: undo03.github.io # MUST HAVE, The repo you use to store Gitment comments
  client_id: 3ea3**************1507b # MUST HAVE, Github client id for the Gitment
  client_secret: 3bcd9a2e****************************d8d5 # EITHER this or proxy_gateway, Github access secret token for the Gitment
  proxy_gateway: # Address of api proxy, See: https://github.com/aimingoo/intersect
  redirect_protocol: # Protocol of redirect_uri with force_redirect_protocol when mint enabled
```

这样基本就ok了，再根据自己的喜好调整样式。

> 注意:
>1.修改themes/next/_config.yml这个文件时，格式要正确。另外，github_repo是你要想创建issues的仓库，完全可以跟博文所放的仓库不一个。github_user就写自己的github用户名就可以，这个用户名跟repo必须匹配。
>2.同一篇文章需要初始化comment两次的问题，是因为http://xxx.com/post/ab9bb85a.html 和点击阅读全文进去的链接  http://xxx.com/post/ab9bb85a.html#more 对issues来说是不同的，所以创建两次。解决方法就是gitment.swig里id使用window.location.pathname而不是document.location.href。
>3.gitment在请求服务器的时候id字段有长度限制，超多长度限制请求会报错，当id是window.location.pathname的时候一般来说都会超长，解决方案是在 md 文件的 front-matter 中增加 subtitle: xxx，在hexo/_config.yml中设置 permalink: :year/:month/:day/:subtitle/ 即可
>4.初始化评论后，可以到github里自己放issues的仓库查看issues是否创建成功，有时候浏览器可能会有缓存依然提示你初始化评论。一般过个两分钟就显示正常了。

> 如需取消某个 页面/文章 的评论，在 md 文件的 `front-matter` 中增加 `comments: false`

### 3.添加版权信息

主题配置文件下,搜索关键字`post_copyright`,enable改为true

```javascript
# Declare license on posts
post_copyright:
  enable: true
  license: CC BY-NC-SA 3.0
  license_url: https://creativecommons.org/licenses/by-nc-sa/3.0/
```

### 4. 开启百度分享

主题配置文件下,搜索关键字`baidushare`,设置以下属性

```javascript
baidushare:
  type: button
  baidushare: true
```

### 5. 搜索

添加百度/谷歌/本地 自定义站点内容搜索

#### 5.1 安装 `hexo-generator-search`，在站点的根目录下执行以下命令：

```javascript
$ npm install hexo-generator-search --save
```

#### 5.2 编辑 站点配置文件，新增以下内容到任意位置：

```javascript
search:
  path: search.xml
  field: post
  format: html
  limit: 10000
```

#### 5.3 编辑 主题配置文件，启用本地搜索功能：

```javascript
local_search:
  enable: true
```

以上搜索服务就配置完成了，再根据主题风格对样式进行修改


	
	