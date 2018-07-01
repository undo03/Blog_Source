---
title: JavaScript中最最基础的知识点
subtitle: js_basics
tags: [JS, JS基础]
date: 2017-06-18
categories: JavaScript
description:
---

`JavaScript` 中有很多很常用的也很基础的知识点需要我们牢牢记住,倒背如流,这样在开发的时候才能得心应手.

本文主要总结了`DOM`,`Array`,`String`,`Math`的一些常用方法,还有一些JS编程的基本常识.

<!--more-->

### 1. DOM

#### 1.1 获取DOM元素

```javascript
document.getElementById
document.getElementsByName
document.getElementsByTagName
document.getElementsByClassName
document.documentElement
document.body
document.querySelector
document.querySelectorAll
```

#### 1.2 DOM节点 

 |nodetype|nodeName|nodeValue
---|:--:|---:|---:
元素节点|1|大写的标签名|null
文本节点|3|#text|文本内容
注释节点|8|#comment|注释内容
document|9|#document|null

#### 1.3 DOM节点属性

```javascript
parentNode
childNodes
children
firstChild  (firstElementChild)
lastChild   (lastElementChild)
previousSibling  (previousElementSibling)
nextSibling (nextElementSibling)
```

#### 1.4 DOM操作

```javascript
createElement
appendChild
insertBefore
replaceChild
removeChild
cloneNode(true/false)
getAttribute
setAttribute
removeAttribute
```

### 2. Array 数组常用方法

```javascript
1.push
2.pop
3.shift
4.unshift
5.splice
    splice(n,m) 删除 返回值：删除的内容以新数组的形式返回
    splice(n,0,x) 添加
    splice(n,m,x) 替换
6.slice
查找 slice(n,m)
克隆 slice()/ slice(0)
7.concat
数组拼接 ary1.concat(ary)
克隆  ary1.concat();
8.toString()
9.join() eval()
10.sort(function(a,b){return a-b})
11.reverse()
12.indexOf() 找到返回对应内容的索引 找不到-1；
13.forEach()
14.map();
15.some();
16.every();
17.forEach();
18.filter();
19.reduce();
20.includes();
```

### 3. 字符串常用方法

```javascript
1.charAt
2.charCodeAt
3.indexOf()
4.lastIndexOf();
5.substr(n,m) 从索引n开始，找m个
6.substring(n,m) 从索引n开始，找到索引m，不包含索引m
7.slice(n,m)从索引n开始，找到索引m，不包含索引m; 可以取负值
8.split() 字符串转数组
9.toUpperCase() 转大写
10.toLowerCase() 转小写
11.replace('','') 替换
12.search() 查找，找到返回索引，找不到-1；
13.match() 匹配
...
```

### 4. Math 常用方法

```javascript
Math.random()
Math.round() 四舍五入
Math.floor() 向下取整
Math.ceil() 向上取整
Math.abs() 取绝对值
Math.min() 取最小值
Math.max() 取最大值
Math.sqrt() 开平方
Math.pow()  幂
```

### 5. 为何学习预解释

1. 如果函数中未定义此变量，为何还能拿到
2. 函数中定义的变量，但是在赋值之前，我们仍然能拿到值，但是拿到是`undefined`
3. 为何把`var`去掉程序还能正常执行；
4. 在定义函数之前，调用函数，也能执行函数，为什么？

最终目的：写代码时，思路更加清楚，知道为何程序能正常执行，为何会报错？避免很多不正规的写法，因为这些不正规的写法很容出错，而且不会报错

### 6. 预解释

**概念：**在当前作用域下，在JS代码执行之前，浏览器会对带`var`和带`function`进行提前声明或者定义；

**声明：**告诉浏览器有这么一个变量，但是没有赋值，没赋值拿到的`undefined`;

**定义：**对已经声明过的这个变量进行赋值

关于变量和函数预解释阶段的不同
> 带`var` :只声明不定义
> 带`function`:声明+定义；

### 7. 函数
    
**定义步骤：**
> 1.开辟一个空间地址
> 2.把函数体中所有JS代码做为字符串存在这个空间中
> 3.把空间地址赋值给函数名

**函数调用步骤：**
> 1.对形参赋值；
> 2.预解释 `var function`;
> 3.JS代码从上到下的执行


### 8. 作用域链

当函数执行的时候，形成一个私有作用域A,查看作用域中的这个变量是否为私有变量：

1）如果是私有变量：这个函数中的所有此变量，跟外面没有任何关系；
2）如果不是私有变量：

1. 如果是获取；往上级作用域进行查找，如果找到，弹出，找不到继续往上级作用域进行查找...最终一直找到`window`，如果还没有，报错
2. 如果是设置；往上级作用域进行查找，如果找到，重新赋值；找不到继续往上级作用域进行查找...最终一直找到`window`，如果还没有，他就是`window`上的全局属性；


### 9. 关于作用域

**全局作用域：**当浏览器加载html页面的时候，会形成一个供JS代码执行的环境；在这个全局作用域下，所有的全局变量都是`window`上的全局属性； 所有的全局函数，都是`window`上的全局方法；
**私有作用域:** 只在某个范围内有效,大多指函数内部

### 10. 带var和不带var的区别
带` var`: 1）会进行预解释 2）如果是全局变量，`window`的全局属性

不带` var`: 1)不会进行预解释 2）如果是设置；往上级作用域进行查找，如果找到，重新赋值；找不到继续往上级作用域进行查找。。。。最终一直找到`window`，如果还没有，他就是`window`上的全局属性；

### 11. 私有变量有且只有两种
1. 函数中带var的
2. 形参

### 12. 关于预解释的无节操：
1. 自执行函数不需要预解释，当代码执行到他的时候；声明+定义+调用同步完成；
2. 已经声明过的变量，不需要重新声明，只需要重新赋值；
3. 对于带`var`的，我们之对等号左边，进行声明；不运行等号右边的（即只声明，不定义）
4. `if` 条件语句，无论条件是否成立，都会进行预解释
注意：在 `if `条件语句中不要定义函数；因为各大浏览器对if语句的预解释不同；很容易出错；
5. `return`返回值不进行预解释；`return`下面的语句虽然不执行，但是会进行预解释；

### 13. 闭包的作用
1. 防止变量名冲突
2. 在闭包中对全局变量重新赋值，并且不影响全局变量
3. 可以通过`window.xx`改变全局变量；
4. 闭包可以用来封装；可以通过`window.xxx=函数名；`

### 14. 函数当作表达式赋值给变量时注意事项：
当函数做为表达式赋值给一个变量的时候，是按照变量的预解释机制进行预解释的；

这个变量名，是不是就相当于函数名，虽然不能在上面调用，但是可以在函数赋值后调用；

### 15. 内存
**js中内存：**堆内存 和 栈内存

**栈内存：**提供了一个供JS代码执行的环境

**环境：**全局环境，私有环境

**堆内存：**存放是引用数据类型的值；对象：存的对象的属性名和属性值； 函数：把函数体中的JS代码做为字符串存在这个空间中

### 16. 内存释放

**堆内存释放：**只要堆内存被变量占用，就无法释放； `var a=xxff00; a=null;`
    解决措施：让 `变量名=null`； 即，让变量名等于空指针，当浏览器空闲的时候，就会把指向空指针的变量收回，浏览器的这种回收机制，叫做垃圾回收机制；
**栈内存：**
全局作用域：当浏览器加载完HTML页面的时候，就形成一个全局作用域；只有关闭页面，才能释放；
如果不关闭页面，那么全局作用域下的所有变量和内容都无法得到释放；
我们唯一能做的就是减少全局变量；
私有作用域：当函数执行的时候，形成一个私有作用域；一般情况下，当函数执行完成的时候私有作用域就被释放；
有两种情况不会被释放：
1. 如果私有函数中有东西被函数外面的变量或者其他元素占用的时候，此函数不能释放；
2. 不立即释放；这个函数执行完成的时候，会返回一个函数，被返回的这个函数还需要再执行一次，等返回的函数执行完成，所有的函数才能释放；

### 17. ++n 和 n++ 的区别
`++n` 先`++`；再运算; `15+（++n）=16;` `15+（++n）=17;`
`n++` 先运算，再`++`; `15+n++=15;` `15+n++=16;`
注意：再`++`时，只是 `n` 自身的`++`；跟整个运算没有关系；

### 18. 关于this的小总结
1. 当触发一个元素身上的事件，执行对应的函数的时候，函数中的`this`，指向当前这个元素；
2. 当函数执行的时候，"."前面是谁，`this`就是谁
3. 自执行函数中的`this`，永远都是`window`；