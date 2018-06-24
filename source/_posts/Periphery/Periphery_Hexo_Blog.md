---
title: Hexo + github 搭建个人博客
subtitle: hexo blog
tags: [hexo,搭建博客]
date: 2017-06-10
categories: Periphery
---
[Hexo](https://hexo.io/zh-cn/) 是高效的静态站点生成框架，她基于 Node.js。 通过 Hexo 你可以轻松地使用 Markdown 编写文章，除了 Markdown 本身的语法之外，还可以使用 Hexo 提供的 标签插件 来快速的插入特定形式的内容。

<!--more-->

## Quick Start

### 必备环境

Git, NodeJs

### Hexo安装

全局安装hexo

```javascript
$ npm install hexo-cli -g
```
到项目目录下初始化hexo项目
```javascript
$ hexo init hexo_test <project name>

$ cd hexo_test && npm install
```

预览项目
```markdown
# 生成静态页面
$ hexo generate 
# 启动本地服务，浏览器访问：http://localhost:4000
$ hexo server  
```
修改项目重新预览
```markdown
# 清空之前生成的静态页面
$ hexo clean

$ hexo generate
$ hexo server
```

### 关联到GitHub

在github上创建项目仓库,仓库名为yourgithubname/github.io
```markdown
# 配置Hexo的_config.yml
deploy:
     type: git
     repo: https://github.com/yourgithubname/yourgithubname.github.io.git
     branch: master
```
> 注意: 这里的repo 是你的git仓库对应的ssh地址,需要先配一下ssh

```markdown
# 要提交到Github上需要安装hexo-deployer-git插件 
$ npm install hexo-deployer-git --save

# 部署网站到Github上
$ hexo deploy

# 访问博客地址：http://undo03.github.io/
# 大功告成!!
```

添加文章等信息,在source/_posts下创建并编辑markdown文件即可,支持文件夹分类,添加完成后按顺序执行以下命令即可部署到http://undo03.github.io/

```markdown
$ hexo clean

$ hexo generate

$ hexo deploy
```

### 更换主题

[hexo主题](https://hexo.io/themes/) 去网站上选一款中意的主题
```markdown
# 从Github下载主题
$ git clone https://github.com/WongMinHo/hexo-theme-miho.git themes/miho
```
在根目下的_config.yml文件中引入主题
```markdown
theme: miho
```
然后重新生成静态文件先本地预览, 然后在主题文件夹下的_config.yml配置基本信息和订制化模块, 一般主题作者会有详细的教程文档和demo, 对应着替换成自己的信息即可

主题定制完成后, 按上面的部署顺序部署即可