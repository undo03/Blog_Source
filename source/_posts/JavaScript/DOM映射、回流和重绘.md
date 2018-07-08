---
title: DOM映射、回流和重绘
subtitle: js_dom_mapping_backflow
tags: [JS, DOM]
date: 2017-08-18
categories: JavaScript
description:
---

**DOM映射**: 通过DOM方法获取的一个元素集合(类数组),这个集合仍然和页面的元素保持着联系,并且这个元素集合会随着页面元素的增加而增加,减少而减少,即使把这个数组转为一个数组,每个元素仍然和页面有联系,这就叫做"DOM映射"

**回流**: 网页内的元素的增加和删除，元素的位置的改变都会引起我们的DOM回流

**重绘**: 元素样式发生改变,就会把当前这个元素重新渲染一遍,进行重绘

<!--more-->

### 1. DOM映射 

**DOM映射**: 通过DOM方法获取的一个元素集合(类数组), 这个集合仍然和页面的元素保持着联系, 并且这个元素集合会随着页面元素的增加而增加, 减少而减少, 即使把这个数组转为一个数组, 每个元素仍然和页面有联系,这就叫做"DOM映射"

更通俗的讲就是, 页面中的标签和js中获取到的元素对象或者元素集合是紧紧的绑定在一起的页面中html结构改变了, js中不需要重新获取, 集合里面的内容也会跟着自动改变

```html
<ul id="list">
    <li>1</li>
    <li>189</li>
    <li>18</li>
    <li>28</li>
</ul>
```

```javascript
var list = document.getElementById("list");
//  js获取到的元素集合
var olis = list.getElementsByTagName("li");
console.log(olis.length); // 4
var li = document.createElement("li");
list.appendChild(li);
// 增加一个li后,元素集合自动改变,不需要重新获取
console.log(olis.length); // 5
//需要注意的是,如果将集合变成数组,这个将失效,如这里将 olis = Array.prototype.slice.call(olis);这样的话,后面的就还是4
```

### 2. 回流与重绘

当render tree中的一部分(或全部)因为元素的规模尺寸，布局，隐藏等改变而需要重新构建。这就称为回流(reflow)。每个页面至少需要一次回流，就是在页面第一次加载的时候。在回流的时候，浏览器会使渲染树中受到影响的部分失效，并重新构造这部分渲染树，完成回流后，浏览器会重新绘制受影响的部分到屏幕中，该过程成为重绘。

当render tree中的一些元素需要更新属性，而这些属性只是影响元素的外观，风格，而不会影响布局的，比如background-color。则就叫称为重绘。

**回流必将引起重绘，而重绘不一定会引起回流。**

**回流何时发生：**
当页面布局和几何属性改变时就需要回流。下述情况会发生浏览器回流：
1. 添加或者删除可见的DOM元素；
2. 元素位置改变；
3. 元素尺寸改变——边距、填充、边框、宽度和高度
4. 内容改变——比如文本改变或者图片大小改变而引起的计算值宽度和高度改变；
5. 页面渲染初始化；
6. 浏览器窗口尺寸改变——resize事件发生时；
    
**如何减少回流、重绘**
1. 直接改变className，如果动态改变样式，则使用cssText（考虑没有优化的浏览器）
2. 让要操作的元素进行"离线处理",处理完后一起更新
    + 使用DocumentFragment进行缓存操作,引发一次回流和重绘；
    + 使用display:none技术，只引发两次回流和重绘；
    + 使用cloneNode(true or false) 和 replaceChild 技术，引发一次回流和重绘；
3. 不要经常访问会引起浏览器flush队列的属性，如果你确实要访问，利用缓存
4. 让元素脱离动画流，减少回流的Render Tree的规模


### 3. 几种动态改变DOM结构的方式

#### 3.1 利用动态创建元素节点和把它追加到页面中的方式实现数据绑定

```javascript
for (var i = 0; i < ary.length; i++) {
    var cur = ary[i];
    var oLi = document.createElement("li");
    oLi.innerHTML = "<span>" + (i + 4) + "</span>" + cur.title;
    oUl.appendChild(oLi);
}
```
  
**优势**：把需要动态绑定的内容一个个的追加到页面中,对原来的元素没有任何的影响
**弊端**：每当创建一个li,我们就添加到页面中,引发一次DOM的回流,最后引发回流的次数过多，影响性能


#### 3.2 字符串拼接的方式

字符串拼接绑定数据是工作中最常用的一种绑定数据的方式, 首先循环需要绑定的数据，然后把需要动态绑定的标签以字符串的方式拼接到一起，拼接完成后，最后统一的添加到页面中
```javascript
var str = "";
for (var i = 0; i < ary.length; i++) {
    var cur = ary[i];
    str += "<li>";
    str += "<span>" + (i + 4) + "</span>";
    str += cur.title;
    str += "</li>";
}
oUl.innerHTML += str;
// oUl.innerHTML=oUl.innerHTML(把之前的三个li以字符串的方式获取到)+str;(拼接完成的整体还是字符串,最后在把字符串统一的添加到页面中，浏览器还需要把字符串渲染成为对应的标签)
```

**弊端**：把新拼接的字符串添加到 `#ul1`中,原有标签绑定的事件也都消失了
**优势**：事先把内容拼接好,最后统一添加到页面中,只引发一次回流

#### 3.3 文档碎片

创建一个文档碎片,相当于临时创建了一个容器, 先在这个容器中进行DOM结构的变化,最后将这个容器当成一个子元素插入到 html 中

```javascript
var frg = document.createDocumentFragment();
for (var i = 0; i < ary.length; i++) {
    var cur = ary[i];

    var oLi = document.createElement("li");
    oLi.innerHTML = "<span>" + (i + 4) + "</span>" + cur.title;
    frg.appendChild(oLi);
}
oUl.appendChild(frg);
frg = null;
```

**弊端**：我们把新拼接的字符串添加到`#ul1`中, 新增加的没有绑定事件
**优势**：事先把内容拼接好,最后统一添加到页面中,也只引发一次回流, 原有的三个`li`绑定的事件还在

以上几种方式都会导致新增的元素绑定的事件失效, 这是因为绑定事件是给每个元素单独绑定的, 要实现子元素无论怎么改变只需要绑定一次事件, 需要用到 `事件委托` 或者 `事件代理`