---
title: Next 主题配置
subtitle: hexo next
tags: [hexo,搭建博客]
date: 2018-06-21
categories: Periphery
---

- 统计文章阅读次数

	到 [leancloud.cn](https://leancloud.cn/) 注册账号，创建应用，
	
	![](https://github.com/undo03/undo03.github.io/blob/master/article_images/1529573803947.jpg?raw=true)
	
	在数据模块中 创建Class，名称一般为 Counter
	
	![](https://github.com/undo03/undo03.github.io/blob/master/article_images/WX20180621-175120.png?raw=true)
	
	然后在设置中拿到该应用的 App ID 、 App Key
	
	![](https://github.com/undo03/undo03.github.io/blob/master/article_images/WX20180621-175238.png?raw=true)

	设置安全域名，只有在允许的域名下才会进行正常的统计
	
	![](https://github.com/undo03/undo03.github.io/blob/master/article_images/WX20180621-175623.png?raw=true)
	
	在主题的_config.yml中进行配置
			
	```javascript
		leancloud_visitors:
		  enable: true
		  app_id: TrNg*****************Hsz #<app_id>
		  app_key: xPUp****************wAk #<app_key>
	```

	重新部署，然后访问，然后去 [leancloud.cn](https://leancloud.cn/) 查看记录
	
	![](https://github.com/undo03/undo03.github.io/blob/master/article_images/WX20180621-175319.png?raw=true)
	
	然后在文章中就可以看到阅读次数了
	
	![](https://github.com/undo03/undo03.github.io/blob/master/article_images/WX20180621-184902.png?raw=true)
	
- 集成评论 gitment
	
	
	