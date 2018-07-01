---
title: 原生JS实现jQuery中的DOM操作
subtitle: js_jQuery_dom
tags: [jQuery, JS, DOM操作]
date: 2017-06-25
categories: JavaScript
description:
---

`jQuery` 是一个 `“写的更少，但做的更多”` 的轻量级 `JavaScript` 库.

基本上，学习到如何选取 `HTML` 元素,以及如何对它们执行类似隐藏、移动以及操作其内容等任务.

这篇文章用原生JS实现`jQuery`中大部分的`DOM操作`的方法.

<!--more-->

为了方便判断浏览器兼容性, 用一下 `flag` 的值代表是否是 `IE8`以上浏览器

```javascript
var flag = 'getComputedStyle' in window;
```

### 1. win 操作浏览器盒子模型

```javascript
//->win:一个有关于操作浏览器盒子模型的方法
//如果只传递了attr没有传递value,默认的意思是“获取”
//如果两个参数都传递了,意思是“设置”

function win(attr, value) {
    if (typeof value === 'undefined') {
        return document.documentElement[attr] || document.body[attr];
    }
    document.documentElement[attr] = value;
    document.body[attr] = value;
}
```

### 2. offset 获取元素相对于body的偏移量

```javascript
/*
* offset：Gets the offset of the current element distance BODY
* @parameter：
*   curEle[object]：current element
* @return：
*   [object]：{top:xxx,left:xxx}
* By Team on 2017-04-23 16:43
*/

function offset(curEle) {
    var par = curEle.offsetParent, totalLeft = curEle.offsetLeft, totalTop = curEle.offsetTop;
    while (par) {
        if (navigator.userAgent.indexOf('MSIE 8.0') === -1) {
            totalLeft += par.clientLeft;
            totalTop += par.clientTop;
        }
        totalLeft += par.offsetLeft;
        totalTop += par.offsetTop;

        par = par.offsetParent;
    }
    return {left: totalLeft, top: totalTop}
}

```

`offset`: 等同于`jQuery`中的`offset`方法,实现获取页面中任意一个元素,距离body的偏移(包含左偏移和上偏移),不管当前元素的父级参照物是谁,获取的结果是一个对象 `{left:距离BODY的左偏移,top:距离BODY的上偏移}`

在标准的`IE8浏览器`中,使用`offsetLeft/offsetTop`其实是把父级参照物的边框已经算在内了,所以我们不需要自己在单独的加边框了

### 3. getCss 获取元素的style属性

```javascript
/*
* getCss：Gets the value of the specific style property for the current element
* @parameter：
*   curEle[object]：current element
*   attr[string]：style properties of elements
* @return：
*   Style attribute values for elements
* By Team on 2017-04-23 12:29
*/
function getCss(curEle, attr) {
    var val = null, reg = null;
    if ('getComputedStyle' in window) {
        val = window.getComputedStyle(curEle, null)[attr];
    } else {    //IE6~8
        switch (attr) {
            case 'filter':
            case 'opacity':
                val = curEle.currentStyle['filter'];
                //reg = /^alpha\(opacity=(\d+(?:\.\d+)?)\)$/i;
                reg = /^alpha\(opacity=(.+)\)$/i;
                val = reg.test(val) ? RegExp.$1 / 100 : 1;
                break;
            default :
                val = curEle.currentStyle[attr];
        }
    }
    reg = /^(?:-?\d+(?:\.\d+)?)(?:px|pt|rem|em)?$/i;
    return reg.test(val) ? parseFloat(val) : val;
}
```

这是兼容写法, 新版浏览器支持`getComputedStyle`获取更方便, `currentStyle` 需要对透明度做特殊处理, 最后为了和`jQuery`保持一致去单位

### 4. setCss 为元素设置style属性

```javascript
function setCss(curEle, attr, value) {
    if (attr === 'opacity') {
        curEle.style['opacity'] = value;
        curEle.style['filter'] = 'alpha(opacity=' + value * 100 + ')';
        return;
    }
    if (attr === 'float') {
        curEle.style['cssFloat'] = value;
        curEle.style['styleFloat'] = value;
        return;
    }
    //给部分样式属性做特殊处理,如果传递进来的样式属性值没有加单位,我们默认给补充px单位
    var reg = /^(?:width|height|(?:(?:margin|padding)?(?:top|right|bottom|left)))$/i;
    if (reg.test(attr)) {
        !isNaN(value) ? value += 'px' : null;
    }
    curEle.style[attr] = value;
}
```

同样为了兼容各个浏览器需要对 `opacity`,`float`做特殊处理,需要对带单位的属性值添加单位

### 5. setGroupCss 为元素设置一组style

```javascript
function setGroupCss(curEle, styleCollection) {
    //循环传递进来的样式集合,调取SETCSS方法,给当前元素逐一设置样式即可
    for (var key in styleCollection) {
        if (styleCollection.hasOwnProperty(key)) {
            setCss(curEle, key, styleCollection[key]);
        }
    }
}
```

### 6. css 
```javascript
function css(curEle) {
    if (arguments.length >= 3) {
        setCss.apply(this, arguments);
        return;
    }
    if (arguments.length === 2 && typeof arguments[1] === 'object') {
        setGroupCss.apply(this, arguments);
    }
    return getCss.apply(this, arguments);
}
```

将 getCss setCss setGroupCss 整合 , 达到`jQuery`中`css`相同的效果

### 7. children 获取元素的子元素  

```javascript
function children(curEle, tagName) {
    var ary = [];
    if (!flag) {
        var nodeList = curEle.childNodes;
        for (var i = 0, len = arguments.length; i < len; i++) {
            var curNode = arguments[i];
            curNode.nodeType === 1 ? ary[ary.length] = curNode : null;
        }
        nodeList = null;
    } else {
        ary = Array.prototype.slice.call(curEle.children);
    }
    if (typeof tagName === 'string') {
        for (var j = 0; j < ary.length; j++) {
            var curEleNode = ary[j];
            if (curEleNode.nodeName !== tagName.toUpperCase()) {
                ary.splice(j, 1);
                j--;
            }
        }
    }
    return ary;
}

```

### 8. prev 获取元素的上一个哥哥元素

```javascript
/*
* prev：获取当前元素的上一个哥哥元素节点(兼容所有浏览器)
* @parameter
*       curEle:current element 当前操作的元素
* @return
*       上一个哥哥元素节点或者是null(没有返回null)
* By Team on 2017-04-08 11:18
*/
function prev(curEle) {
    if (flag) {
        return curEle.previousElementSibling;
    }
    var pre = curEle.previousSibling;
    if (pre && pre.nodeType !== 1) {
        pre = pre.previousSibling;
    }
    return pre;
}
```

### 9. prevAll 获取元素的所有哥哥元素

```javascript
 /*
* prevAll：获取当前元素的所有哥哥元素节点(兼容所有浏览器)
* @parameter
*       curEle:current element 当前操作的元素
* @return
*       所有的哥哥元素节点或者是null(没有返回null)
* By Team on 2017-04-08 11:18
*/
function prevAll(curEle) {
    var ary = [], pre = prev(curEle);
    while (pre) {
        ary.push(pre);
        pre = prev(pre);
    }
    return ary;
}
```

### 10. next 获取元素的下一个弟弟元素

```javascript
/*
* next：获取当前元素的下一个弟弟元素节点(兼容所有浏览器)
* @parameter
*       curEle:current element 当前操作的元素
* @return
*       下一个弟弟元素节点或者是null(没有返回null)
* By Team on 2017-04-08 11:18
*/
function next(curEle) {
    if (flag) {
        return curEle.nextElementSibling;
    }
    var nex = curEle.nextSibling;
    if (nex && nex.nodeType !== 1) {
        nex = nex.nextSibling;
    }
    return nex;
}
```

### 11. nextAll 获取元素的所有弟弟元素

```javascript
/*
* nextAll：获取当前元素的所有弟弟元素节点(兼容所有浏览器)
* @parameter
*       curEle:current element 当前操作的元素
* @return
*       所有的弟弟元素节点或者是null(没有返回null)
* By Team on 2017-04-08 11:18
*/
function nextAll(curEle) {
    var ary = [], nex = next(curEle);
    while (nex) {
        ary.push(nex);
        nex = next(nex);
    }
    return ary;
}
```

### 12. sibling 获取元素相邻元素

```javascript
function sibling(curEle) {
    var pre = prev(curEle);
    var nex = next(curEle);
    var ary = [];
    pre ? ary.push(pre) : null;
    nex ? ary.push(nex) : null;
    return ary;
}
```

### 13. siblings 获取元素的所有兄弟元素

```javascript
function siblings(curEle) {
    return this.prevAll(curEle).concat(nextAll(curEle));
}
```

### 14. index 获取元素所在的索引

```javascript
function index(curEle) {
    return prevAll(curEle).length;
}
```

### 15. firstChild 获取第一个子节点

```javascript
function firstChild(curEle) {
    var chs = children(curEle);
    return chs.length > 0 ? chs[0] : null;
}
```

### 16. lastChild 获取最后一个子节点

```javascript
function lastChild(curEle) {
        var chs = children(curEle);
        return chs.length > 0 ? chs[chs.length - 1] : null;
    }
```

### 17. append 向指定容器的末尾追加元素

```javascript
function append(newEle, container) {
    container.appendChild(newEle);
}
```

### 18. prepend 向指定容器的开头追加元素

把新的元素添加到容器中第一个子元素节点的前面,如果一个元素子节点都没有,就放在末尾即可

```javascript
function prepend(newEle, container) {
    var fir = firstChild(container);
    if (fir) {
        container.insertBefore(newEle, fir);
        return;
    }
    container.appendChild(curEle);
}
```
### 19. insertBefore 把新元素追加到指定元素的前面

```javascript
function insertBefore(newEle, oldEle) {
    oldEle.parentNode.insertBefore(newEle, oldEle);
}
```

### 20. insertAfter 把新元素追加到指定元素的后面

相当于追加到oldEle弟弟元素的前面,如果弟弟不存在,也就是当前元素已经是最后一个了,我们把新的元素放在最末尾即可

```javascript
 function insertAfter(newEle, oldEle) {
    var nex = next(oldEle);
    if (nex) {
        oldEle.parentNode.insertBefore(newEle, nex);
        return;
    }
    oldEle.parentNode.appendChild(newEle);
}
```

### 21. hasClass 判断元素是否有某个class

```javascript
function hasClass(curEle, cName) {
    return new RegExp('\\b' + cName + '\\b').test(curEle.className);
}
```

### 22. addClass 为元素添加class

```javascript
function addClass(curEle, strClass) {
    strClass = strClass.replace(/(^ +| +$)/g, "").split(/ +/g);
    for (var i = 0, len = strClass.length; i < len; i++) {
        var curClass = strClass[i];
        if (!hasClass(curEle, curClass)) {
            curEle.className += " " + curClass;
        }
    }
}
```

### 23. removeClass 移除元素中的class

```javascript
function removeClass(curEle, strClass) {
    strClass = strClass.replace(/(^ +| +$)/g, "").split(/ +/g);
    for (var i = 0, len = strClass.length; i < len; i++) {
        var curClass = strClass[i];
        var reg = new RegExp("(^| +)" + curClass + "( +|$)", "g");
        hasClass(curEle, curClass) ? curEle.className = curEle.className.replace(/ /g,'  ').replace(reg, " ") : null;
        curEle.className = curEle.className.replace(/(^ +| +$)/, " ");
    }
}
```

### 24. toggleClass 切换元素的class

```javascript
function toggleClass(curEle, strClass) {
    strClass = strClass.replace(/(^ +| +$)/g, "").split(/ +/g);
    for (var i = 0; i < strClass.length; i++) {
        var curClass = strClass[i];
        hasClass(curEle, curClass) ? removeClass(curEle, curClass) : addClass(curEle, curClass);
    }
}
```

### 25. getElementsByClass

```javascript
function getElementsByClass(strClass, context) {
    context = context || document;
    if (flag) {
        return listToArray(context.getElementsByClassName(strClass));
    }
    strClass = strClass.replace(/(^ +| +$)/g, '').replace(/ +/g, '@@').replace(/(?:^|@)([\w-]+)(?:@|$)/g, '(?=.*(^| +)$1( +|$).*)');
    var ary = [], reg = new RegExp(strClass),
        nodeList = context.getElementsByTagName('*');
    for (var i = 0; i < nodeList.length; i++) {
        var curNode = nodeList[i];
        reg.test(curNode.className) ? ary[ary.length] = curNode : null;
    }
    return ary;
}
```

正则的方式比较简单,但是正则不容易写出来,还有其他的方式

```javascript
function getElementsByClass(strClass, context) {
    context = context || document;
    if ('getComputedStyle' in window) {
        return [].slice.call(context.getElementsByClassName(strClass));
    }
    var ary = [], strClassAry = strClass.replace(/(^ +| +$)/g, '').split(/ +/g);
    var nodeList = context.getElementsByTagName('*');
    for (var i = 0; i < nodeList.length; i++) {
        var curNode = nodeList[i];
        var isTrue = true;
        for (var j = 0; j < strClassAry.length; j++) {
            var curName = strClassAry[j];
            if (!hasClass(curNode, curName)) {
                isTrue = false;
                break;
            }
        }
        if (isTrue) {
            ary.push(curNode);
        }
    }
    return ary;
}
```

### 总结

以上实现了大部分的常用的DOM操作的兼容写法,目的不在于去实现`jQuery`中API,而是从原理上理解`jQuery API`的实现原理,锻炼个人的编程能力,升华编程思想.
