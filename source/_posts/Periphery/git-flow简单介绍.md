---
title: git-flow 工作流程
subtitle: git_git_flow
tags: [Git]
date: 2017-08-12
categories: Git
---

## 一、前言

git 最强大的就是其分支功能，但是如何分支才能更有效的提高开发效率，减少因为代码合并带来的问题，需要一个分支模型来规范，其实在 git flow 出现之前，已经有分支模型理论流程，当时是根据此理论，手动的按照规范操作分支，git flow 出现之后，将一部分操作流程简化为命令，并没有增加新的功能，只是简化了操作。

<!--more-->

## 二、git-flow 简介

安装`git-flow`后，你将会拥有一些扩展命令。这些命令会在一个预定义的顺序下自动执行多个操作。
`git-flow` 并不是要替代 Git，它仅仅是非常聪明有效地把标准的 Git 命令用脚本组合了起来。
严格来讲，你并不需要安装什么特别的东西就可以使用 `git-flow` 工作流程。你只需要了解，哪些工作流程是由哪些单独的任务所组成的，并且附带上正确的参数，以及在一个正确的顺序下简单执行那些对应的 Git 命令就可以了。当然，如果你使用 `git-flow` 脚本就会更加方便了，你就不需要把这些命令和顺序都记在脑子里。

## 三、安装
目前流行的是 avh 版本的 git-flow
```bash
# 稳定版
brew install git-flow-avh
# 开发板
brew install git-flow-avh --HEAD
```

## 四、初始化项目

```bash
# cd /pass/to/your/project
# 执行下面的命令，不需要执行 git init
git flow init
```

## 五、分支模型

用 git flow 初始化工程目录完成后，只能看到两个分支：

Gitflow使用两个分支来记录项目开发的历史，而不是使用单一的master分支。在Gitflow流程中，master只是用于保存官方的发布历史，而develop分支才是用于集成各种功能开发的分支。使用版本号为master上的所有提交打标签（tag）也很方便。
![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/2018-07-04_13-04-49.png?raw=true)
事实上，Gitflow流程就是围绕这两个特点鲜明的分支展开的。

### master 分支
用于上线的分支，保护性分支，只包含经过测试的稳定代码，开发人员不能直接工作在此分支上，也不能直接提交改动到 master 分支上。

### develop分支
是开发人员进行任何新的开发的基础分支，当开始一个新的feature 分支的时候，要从 develop 分出去；另外此分支也汇集所有的已完成的功能，等待合并到 master 分支上线。

上面两个分支被称为**长期分支**  ，存在于项目的整个生命周期中，其他分支，是临时性的，根据需要来创建，当完成了自己的任务后，就会被删掉。

### feature 分支

平常的开发工作使用最频繁的分支。每一个新功能的开发都应该各自使用独立的分支。为了备份或便于团队之间的合作，这种分支也可以被推送到中央仓库。但是，在创建新的功能开发分支时，父分支应该选择develop（而不是master）。当功能开发完成时，改动的代码应该被合并（merge）到develop分支。功能开发永远不应该直接牵扯到master。
![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/2018-07-04_13-07-31.png?raw=true)


#### 1. 开始一个feature分支
如下命令会创建一个名为”feature/” 的功能分支，该分支默认从 develop检出，在做功能性开发的时候，检出一个独立的分支，是版本控制中一个重要 的原则。

```bash
# git-flow 创建 feature 分支
$ git flow feature start <branch-name>
```

#### 2. 完成一个feature分支

```bash
# git-flow 完成一个 feature 分支 
$ git flow feature finish <branch-name>
```

该命令会把我们在当前分支的代码整合到‘develop’分支中去，之后，git-flow 会进行清理操作，删除当下完成的功能分支，将分支切换到‘develop’。

### release 分支

一旦develop分支积聚了足够多的新功能（或者预定的发布日期临近了），你可以基于develop分支建立一个用于产品发布的分支。这个分支的创建意味着一个发布周期的开始，也意味着本次发布不会再增加新的功能——在这个分支上只能修复bug，做一些文档工作或者跟发布相关的任务。在一切准备就绪的时候，这个分支会被合并入master，并且用版本号打上标签。另外，发布分支上的改动还应该合并入develop分支——在发布周期内，develop分支仍然在被使用（一些开发者会把其他功能集成到develop分支）。使用专门的一个分支来为发布做准备的好处是，在一个团队忙于当前的发布的同时，另一个团队可以继续为接下来的一次发布开发新功能。

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/2018-07-04_13-13-20.png?raw=true)

#### 1.创建一个release分支

当你认为现在在 “develop” 分支的代码已经是一个成熟的 release 版本时，这意味着：第一，它包括所有新的功能和必要的修复；第二，它已经被彻底的测试过了。如果上述两点都满足，那就是时候开始生成一个新的 release 了：

```bash
$ git flow release start 1.1.5
Switched to a new branch 'release/1.1.5'
```

请注意，release 分支是使用版本号命名的。这是一个明智的选择，这个命名方案还有一个很好的附带功能，那就是当我们完成了release 后，git-flow 会适当地_自动_去标记那些 release 提交。

有了一个 release 分支，再完成针对 release 版本号的最后准备工作（如果项目里的某些文件需要记录版本号），并且进行最后的编辑。

#### 2. 完成一个release分支

```bash
$ git flow release finish 1.1.5
```

这个命令会完成如下一系列的操作：

1. 首先，git-flow 会拉取远程仓库，以确保目前是最新的版本。
2. 然后，release 的内容会被合并到 “master” 和 “develop” 两个分支中去，这样不仅产品代码为最新的版本，而且新的功能分支也将基于最新代码。
3. 为便于识别和做历史参考，release 提交会被标记上这个 release 的名字（在我们的例子里是 “1.1.5”）。
4. 清理操作，版本分支会被删除，并且回到 “develop”。

从 Git 的角度来看，release 版本现在已经完成。依据你的设置，对 “master” 的提交可能已经触发了你所定义的部署流程，或者你可以通过手动部署，来让你的软件产品进入你的用户手中。

### hotfix分支

发布后的维护工作或者紧急问题的快速修复也需要使用一个独立的分支。这是唯一一种可以直接基于master创建的分支。一旦问题被修复了，所做的改动应该被合并入master和develop分支（或者用于当前发布的分支）。在这之后，master上还要使用更新的版本号打好标签。
![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Perphery/2018-07-04_13-36-09.png?raw=true)

#### 1. 创建一个hotfix分支

```bash
$ git flow hotfix start missing-link
```

这个命令会创建一个名为“hotfix/missing-link” 的分支。因为这是对产品代码进行修复，所以这个hotfix分支是基于“master”分支。

这也是和 release 分支最明显的区别，release 分支都是基于 “develop” 分支的。因为你不应该在一个还不完全稳定的开发分支上对产品代码进行地修复。

就像 release 一样，修复这个错误当然也会直接影响到项目的版本号！

#### 2.完成一个hotfix分支

在把我们的修复提交到hotfix分支之后，就该去完成它了：

```bash
$ git flow hotfix finish missing-link
```

这个过程非常类似于发布一个 release 版本：

+ 完成的改动会被合并到 “master” 中，同样也会合并到 “develop” 分支中，这样就可以确保这个错误不会再次出现在下一个 release 中。
+ 这个 hotfix 会被标记起来以便于参考。
+ 这个 hotfix 分支将被删除，然后切换到 “develop” 分支上去。

还是和产生 release 的流程一样，现在需要编译和部署你的产品（如果这些操作不是自动被触发的话）。

## 六、总结

#### 主要分支
**master**: 项目的主要分支，对外的第一门面。所有人浏览项目，使用项目，第一时间看到的是master。永远处在即将发布(production-ready)状态。
**develop**: 处于功能开发的最前线的版本，查看develop分支就能知道下一个发布版本有哪些功能了。develop一开始是从master里分出来的，并且定期会合并到master里，每一次合并到master，表示我们完成了一个阶段的开发，产生一个稳定版。同样的，develop下也不建议直接开发代码，develop代表的是已经开发好的功能的**回归**版本。最后，在适当的时候，由合适的人，合并到master，作为下一个稳定版本。

> feature的作用是为每一个新功能从develop里创建出来的一个分支。例如小明和小白分别做两个不相干的功能，就应该分别创建两个分支，各自开发完以后，先后合并到develop里，这就叫做**回归**。


#### 辅助分支
**feature**: 开发新功能的分支, 基于 develop, 完成后 merge 回 develop
**release**: 准备要发布版本的分支, 也基于 develop, 完成后 merge 回 develop 和 master
**hotfix**: 修复 master 上的问题, 等不及 release 版本就必须马上上线. 基于 master, 完成后 merge回 master 和 develop


**本文转载自**: [https://www.lishuaishuai.com/tool/791.html](https://www.lishuaishuai.com/tool/791.html)