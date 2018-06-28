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

```javascript
$ git branch new_branch_name 7c6fa98
$ git merge new_branch_name
$ git branch -D new_branch_name
```

参考文章: 
[如何从detached HEAD状态解救出来](https://www.jianshu.com/p/ae4857d2f868)
[斷頭（detached HEAD）是怎麼一回事？](https://gitbook.tw/chapters/faq/detached-head.html)
