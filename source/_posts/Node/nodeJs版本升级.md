---
title: 升级本地已安装的 Node 和 npm 版本
subtitle: node_npm_update
tags: [node, npm]
date: 2017-07-18
categories: NodeJS
description:
---

`Mac`升级本地已经安装的`NodeJs`和`Npm`到最新版,可以使用一下方式进行升级和更新。

其实`windos`上升级`nodejs`也很简单，只需在`nodejs`官网下载安装最新的`msi`即可。

值得注意的是安装时需要按原`nodejs`安装路径路径安装，不能安装到新的路径。

<!--more-->

### 1. Node 版本升级

**step1：** 查看本机当前 `node` 版本

```javascript
node -v
```
**step2：** 清除`nodejs`的 `cache`

```javascript
npm cache clean -f
```

**step3：** 安装`node`管理工具 `n`

这个工具是专门用来管理`nodejs`版本的，别怀疑这个工具的名字, 他的名字就是 `"n"`

```javascript
npm install -g n
```
**step4：** 安装不同版本的 `nodejs`

```javascript
// 安装最新版本
n latest

// 安装稳定版本
n stable

// 安装或使用某一个版本
n 8.2.0

// 删除某个版本
n rm 6.7.0
```

**step5：** 再次查看 `node` 版本

```javascript
node -v
```

### 2. 更新 `npm` 到最新版本

```javascript
npm install npm@latest -g
```
