---
title: 手动实现数组的slice方法
subtitle: js_array_slice
tags: [JS, slice, Array]
date: 2017-06-21
categories: JavaScript
description:
---

数组是我们开发中最常用的数据类型之一,有强大的API接口和功能供我们使用. 

找工作面试的时候难免会问一些API的实现原理或者手写某个API,下面记录一下我自己实现的数组的 `slice` 方法

<!--more-->

### 1. 准备工作

`slice([begin],[end])` 方法返回一个从开始到结束（不包括结束）选择的数组的一部分浅拷贝到一个新数组对象。且原始数组不会被修改。

要实现这个API,首先得充分使用它,了解它的工作原理,输入什么,输出什么.

`slice` 方法的参数情况比较复杂,有很多种,需要尝试各种传参方式,看输出结果,总结参数的处理规律.

一番尝试之后发现,其实实现这个 API 主要在于参数的处理,对各种可能的参数进行兼容处理,就基本能够实现它

**参数解读**

`begin` [可选]

从该索引处开始提取原数组中的元素（从0开始）。

如果该参数为负数，则表示从原数组中的倒数第几个元素开始提取，`slice(-2)`表示提取原数组中的倒数第二个元素到最后一个元素（包含最后一个元素）。

如果省略 `begin`，则 `slice` 从索引 0 开始。

`end` [可选]

在该索引处结束提取原数组元素（从0开始）。`slice`会提取原数组中索引从 `begin` 到 `end` 的所有元素（包含begin，但不包含end）。

`slice(1,4`) 提取原数组中的第二个元素开始直到第四个元素的所有元素 （索引为 1, 2, 3的元素）。

如果该参数为负数， 则它表示在原数组中的倒数第几个元素结束抽取。 `slice(-2,-1)`表示抽取了原数组中的倒数第二个元素到最后一个元素（不包含最后一个元素，也就是只有倒数第二个元素）。

如果` end` 被省略，则`slice` 会一直提取到原数组末尾。

如果 `end` 大于数组长度，`slice` 也会一直提取到原数组末尾。

### 2. 着手实现

在数组的原型上添加我自己实现的 `mySlice` 方法

```javascript
Array.prototype.mySlice = function mySlice(begin, end) {
    var ary = [], _end = typeof end === "undefined" ? this.length : end;
    var n = Number(begin) || 0, m = Number(_end) || 0;
    n = n < 0 ? ((n + this.length) < 0 ? 0 : Math.ceil(n + this.length)) : Math.floor(n);
    m = m < 0 ? Math.ceil(m + this.length) : (m <= this.length ? Math.floor(m) : this.length);
    for (var i = n; i < m; i++) {
        ary[ary.length] = this[i];
    }
    return ary;
};
```

以上是按照传参的规律进行实现的 `mySlice` 方法,包括处理 传递非数字参数,小数参数等情况

可以测试一下,与原 `slice` 方法做下对比, 遇到没处理好的参数情况再进行优化.

**我的测试用例:**

```javascript
var ary = [23, 14, 5, 6, 56, 78, 32, 11];
console.log("mySlice: ", ary.mySlice(1, 4));
console.log("slice: ", ary.mySlice(1, 4));

console.log(ary.slice({}));
console.log(ary.mySlice({}));

console.log(ary.slice(-(ary.length + 1)));
console.log(ary.mySlice(-(ary.length + 1)));

console.log(ary.slice(-1));
console.log(ary.mySlice(-1));

console.log(ary.slice(-1.2));
console.log(ary.mySlice(-1.2));

console.log(ary.slice(ary.length));
console.log(ary.mySlice(ary.length));

console.log(ary.slice(3));
console.log(ary.mySlice(3));

console.log(ary.slice(3.2));
console.log(ary.mySlice(3.2));

console.log(ary.slice(undefined));
console.log(ary.mySlice(undefined));

console.log(ary.slice(3, 1));
console.log(ary.mySlice(3, 1));

console.log(ary.slice(33, 111));
console.log(ary.mySlice(33, 111));

console.log(ary.slice(-333, -111));
console.log(ary.mySlice(-333, -111));

console.log(ary.slice(-12, -2));
console.log(ary.mySlice(-12, -2));

console.log(ary.slice(-12, 3));
console.log(ary.mySlice(-12, 3));

console.log(ary.slice(-12, 13));
console.log(ary.mySlice(-12, 13));

console.log(ary.slice(-9, -5));
console.log(ary.mySlice(-9, -5));

console.log(ary.slice(-1, 2));
console.log(ary.mySlice(-1, 2));

console.log(ary.slice(-5, 7));
console.log(ary.mySlice(-5, 7));

console.log(ary.slice(-5, 17));
console.log(ary.mySlice(-5, 17));

console.log(ary.slice(2, 5));
console.log(ary.mySlice(2, 5));

console.log(ary.slice(3, 18));
console.log(ary.mySlice(3, 18));


console.log(ary.slice(NaN, -11));
console.log(ary.mySlice(NaN, -11));

console.log(ary.slice(NaN, -5));
console.log(ary.mySlice(NaN, -5));

console.log(ary.slice(NaN, 11));
console.log(ary.mySlice(NaN, 11));

console.log(ary.slice(NaN, 5));
console.log(ary.mySlice(NaN, 5));

console.log(ary.slice(5, NaN));
console.log(ary.mySlice(5, NaN));

console.log(ary.slice(undefined, NaN));
console.log(ary.mySlice(undefined, NaN));

console.log(ary.slice(undefined, -111));
console.log(ary.mySlice(undefined, -111));

console.log(ary.slice(undefined, -3));
console.log(ary.mySlice(undefined, -3));

console.log(ary.slice(undefined, 0));
console.log(ary.mySlice(undefined, 0));

console.log(ary.slice(undefined,5));
console.log(ary.mySlice(undefined, 5));

console.log(ary.slice(undefined, 111));
console.log(ary.mySlice(undefined, 111));

console.log(ary.slice(undefined, null));
console.log(ary.mySlice(undefined, null));

console.log(ary.slice(NaN, undefined));
console.log(ary.mySlice(NaN, undefined));

console.log(ary.slice(-111, undefined));
console.log(ary.mySlice(-111, undefined));

console.log(ary.slice(-3, undefined));
console.log(ary.mySlice(-3, undefined));

console.log(ary.slice(0, undefined));
console.log(ary.mySlice(0, undefined));

console.log(ary.slice(2, undefined));
console.log(ary.mySlice(2, undefined));

console.log(ary.slice(111, undefined));
console.log(ary.mySlice(111, undefined));

console.log(ary.slice(null, undefined));
console.log(ary.mySlice(null, undefined));

console.log(ary.slice(undefined, undefined));
console.log(ary.mySlice(undefined, undefined));
```
