---
title: Git 常用遇到的问题
subtitle: git_common_problem
tags: [Git]
date: 2017-07-12
categories: Git
---

开发中经常遇到一些奇奇怪怪的状况，以下是记录工作中遇到过的 `Git` 使用出现的问题，做以下记录

### 常遇到的问题

#### 1. git add ， git commit 添加错文件 撤销
<!--more-->
`git add` 添加 多余文件

`git status` 先看一下add 中的文件 
`git reset HEAD` 如果后面什么都不跟的话 就是上一次add 里面的全部撤销了 
`git reset HEAD xxx/xxx/xxx.js` 就是对某个文件进行撤销了

`git commit` 错误

```javascript
git log // 查看节点 
commit xxxxxxxxxxxxxxxxxxxxxxxxxx 
git reset commit_id
```

#### 2. 撤销修改

```javascript
git checkout . 
git checkout file
```

#### 3. Git：refname’master’是不明确的

`warning: refname 'branch-name' is ambiguous`

```javascript
$ git checkout RELEASE
warning: refname 'RELEASE' is ambiguous.
Switched to branch 'RELEASE'
Your branch is up to date with 'origin/RELEASE'.
```
解决方案

```javascript
git tag tag-master master
git tag -d master
```
原文: [Git：refname’master’是不明确的](https://codeday.me/bug/20171218/110944.html)

#### 4. HEAD detached at head

HEAD 没有指到某个分支的時候，它会呈现 detached 状态。事实上，更正确的说，应该是「当 HEAD 没有指到某个『本地』的分支」就会呈现这种状态

```javascript
$ git checkout  origin/TEST
Note: checking out 'origin/TEST'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at e53d4cba update
```
   
```javascript
$ git branch
* (HEAD detached at origin/TEST)
  RELEASE
  dev_register_sqb
  master
```

要切换到远端分支而不呈现 detached HEAD 状态，可以加上 --track 或 -t 参数, -t 参数是指会在本地建立一个名为追踪分支（tracking branch）的东西

```javascript
$ git checkout -t origin/TEST
Branch 'TEST' set up to track remote branch 'TEST' from 'origin'.
Switched to a new branch 'TEST'

$ git branch
  RELEASE
* TEST
  dev_register_sqb
  master
```

参考文章: 
[斷頭（detached HEAD）是怎麼一回事？](https://gitbook.tw/chapters/faq/detached-head.html)
[如何从detached HEAD状态解救出来](https://www.jianshu.com/p/ae4857d2f868)
