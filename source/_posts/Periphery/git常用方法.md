---
title: Git 常用操作
subtitle: git_basis
tags: [Git]
date: 2017-07-11
categories: Git
---

`Git` 是一个开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目。

`Git` 不仅仅是个版本控制系统，它也是个内容管理系统(CMS),工作管理系统等。

`Git` 是 `Linus Torvalds` 为了帮助管理 `Linux` 内核开发而开发的一个开放源码的版本控制软件。
<!--more-->
`Git` 与常用的版本控制工具 `CVS`, `Subversion` 等不同，它采用了分布式版本库的方式，不必服务器端软件支持。

### 1. 安装和配置

在使用`Git`前需要先安装 `Git`。`Git` 目前支持 `Linux/Unix`、`Solaris`、`Mac`和 `Windows` 平台上运行。

`Git` 各平台安装包下载地址为：[http://git-scm.com/downloads](http://git-scm.com/downloads)

配置个人的用户名称和电子邮件地址:

```javascript
git config --global user.name "undo"
git config --global user.email myundo@163.com
```

要检查已有的配置信息，可以使用 `git config --list` 命令：

```javaascript
git config --list

user.name=undo
user.email=myundo@163.com
...
```

### 2. Git 工作流程

一般工作流程如下：

- 克隆 Git 资源作为工作目录。
- 在克隆的资源上添加或修改文件。
- 如果其他人修改了，你可以更新资源。
- 在提交前查看修改。
- 提交修改。
- 在修改完成后，如果发现错误，可以撤回提交并再次修改并提交。

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/gitworkflow.png?raw=true)

### 3. Git 工作区、暂存区和版本库

- **工作区**：就是你在电脑里能看到的目录。
- **暂存区**：英文叫stage, 或index。一般存放在"git目录"下的index文件中，所以我们把暂存区有时也叫作索引（index）。
- **版本库**：工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。

### 4. Git 基本操作

#### 4.1 创建仓库

```javascript
// 在已有项目目录下
git init

// 指定仓库目录
git init newrepo

// 克隆项目并重新命名
git clone [url] rename
```

#### 4.2 工作流程

大致流程使用如下

```javascript
mkdir proDemo
cd proDemo
git init
git add .
git commit -m 'commit'
```

`git add` 提交缓存，后面加 ` .` 或者 `-a`， 表示全部缓存，也可以 `git add file` 提交文件， 多个文件用空格隔开

```javascript
git add .
git add file
git add flieA fileB
```

`git commit` 为本次提交添加备注, ` -m` 选项在命令行中提供提交注释, 没有设置 `-m` 选项，`Git` 会尝试为你打开一个编辑器以填写提交信息.

```javascript
git commit -m 'commit'
```
`git add` 和 `git commit` 可以合并为

```javascript
git commit -am 'commit'
```

`git reset HEAD` 命令用于取消缓存已缓存的内容

```javascript
git reset HEAD // 撤销本次提交
git reset HEAD -- hello.js // 撤销单个文件的提交
```

`git rm` 将文件从缓存区中移除,默认情况下,`git rm file` 会将文件从缓存区和你的硬盘中（工作目录）删除。 如果要在工作目录中留着该文件，可以使用命令：

```javascript
 git rm hello.js --cached
```

### 5. Git 分支管理

**查看分支**

```javascript
git branch
```

**新建分支**

```javascript
git branch (branchname)
git checkout -b (branchname)
```

**切换分支**

```javascript
git checkout (branchname)
```

**删除分支**

```javascript
git branch -d (branchname)
```

**分支合并**

```javascript
git merge (branchname)
```

**合并冲突**

```javascript
git merge test
CONFLICT (content): Merge conflict in test.txt
```

`CONFLICT`表示合并冲突就出现了,需要手动去修改它, 用 `git add` 告诉 `Git` 文件冲突已经解决, 然后继续 `commit`

**查看提交历史**

```javascript
git log
```

用 `--oneline` 选项来查看历史记录的简洁的版本,  `--graph` 选项,查看历史中什么时候出现了分支、合并, 用 `--reverse` 参数来逆向显示所有日志, `--author` 查找指定用户的提交日志

指定日期: `--since` 和 `--before`，也可以用 `--until` 和 `--after`

`--no-merges` 选项以隐藏合并提交

```javascript
git log --oneline
git log --oneline --graph
git log --reverse --oneline
git log --author=Linus --oneline
git log --oneline --before={3.weeks.ago} --after={2017-06-18} --no-merges
```

### 6. Git 管理远程分支

**查看远程连接**

```javascript
git remote
```

`-v` 参数可以看到每个别名的实际链接地址

**添加远程连接**

```javascript
git remote add [shortname] [url]
```

`shortname ` 添加一个新的远程仓库，可以指定一个简单的名字，以便将来引用

**提取远程仓库**

`git fetch` 从远程仓库下载新分支与数据

```javascript
git fetch
```
`git pull` 从远端仓库提取数据并尝试合并到当前分支, `[shortname/branchname]` 参数可以将指定连接的指定分支代码合并到当前分支

```javascript
git pull [shortname/branchname]
```

`git merge ` 加参数 `shortname/branchname`,也会合并远程分支到当前本地分支

```javascript
git merge [shortname/branchname]
```

**推送到远程仓库**

```javascript
git push [shortname] [branch]
```

**删除远程仓库**

```javascript
git remote rm [shortname]
```

**删除远程分支和tag**

```javascript
git push origin --delete <branchName>
git push origin --delete tag <tagname>
```

否则，可以使用这种语法，推送一个空分支到远程分支，其实就相当于删除远程分支,删除tag的方法，推送一个空tag到远程tag

```javascript
git push origin :<branchName>

git tag -d <tagname>
git push origin :refs/tags/<tagname>
```

删除不存在对应远程分支的本地分支

```javascript
git fetch -p
```

重命名远程分支

在git中重命名远程分支，其实就是先删除远程分支，然后重命名本地分支，再重新提交一个远程分支

```javascript
git push --delete origin devel

git branch -m devel develop

git branch -m devel develop

```
**参考链接**
[W3Cschool Git教程](https://www.w3cschool.cn/git/)
[Git查看、删除、重命名远程分支和tag](http://blog.zengrong.net/post/1746.html)