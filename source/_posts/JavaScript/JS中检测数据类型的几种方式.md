---
title: JS中检测数据类型的几种方式
subtitle: js_detection_data_type
tags: [JS, JS基础, 检测数据类型]
date: 2017-06-20
categories: JavaScript
description:
---

JS中检测数据类型的方式有多种,各种方式都有它的特点和局限性,在使用的时候可以根据业务场景进行合理的选择.

常用的方式有 `typeof` , `instanceof` , `constructor` , `Object.prototype.toString`

<!--more-->

### 1. typeof

检测基本数据类型, 返回的是 `"number"`, `"string"`, `"boolean"`, `"undefined"`, `"object"`, `"function"`表示这些数据类型的`"字符串"`

**局限性：** 没办法检测复杂的引用数据类型的具体数据类型,`typeof null`  得到的是  `"object"`
对于引用数据类型的返回值：
```javascript
console.log(typeof [])   // "object"
console.log(typeof {})   // "object"
console.log(typeof /$/)  // "object"
console.log(typeof isNaN) // "function"
```
**规律：** 多个typeof连续使用的时候返回的都是`"string"`
```javascript
console.log(typeof(typeof(typeof(typeof []))))  "string"
```

### 2. instanceof 

**语法：** `[] instanceof Array` 返回  `true` or `false`
`instanceof` 用来检测`"引用类型"`的具体数据类型，判断实例是否属于某个类,不能判断`"字面量方式申明的"`基本数据类型
但是可以检测实例方式创建的基本数据类型的值，如下：
```javascript
var c = new String('qwe');
console.log(c instanceof String)  //  true
var num = new Number(12);
console.log(num instanceof Number) //  true
```

由于原型链查找机制,会导致检测不准确,或者说不是想要的结果
```javascript
var c = new String('qwe');
console.log(c instanceof Object)  //  true
console.log(c instanceof String)  //  true
```
### 3. constructor

`constructor` 检测目标对象是否是某个类的构造类,除了不能检测`null`和`undefined`，其他的都能检测
**语法：** `实例.constructor === 构造函数` 返回 `true` or `false`
```javascript
console.log([].constructor === Array)  //  true
console.log('2'.constructor === Array)  //  false
console.log('2'.constructor === String) // true
```
`null` 和 `undefined` 不能使用 `constructor` 来检测,语法上直接会报错
在自定义类中如果重写了原型,而没有将`constructor`重新指回该类的话,使用这种方式检测也会出现问题.

### 4. Object.prototype.toString

以上三种方式都是有缺陷的,不能适用于所有的数据类型或者检测结果不准确,但是 这种方式能够满足准确检测所有的数据类型

**语法:** `Object.prototype.toString.call([]);` 返回字符串 ` "[object Array]"`

```javascript
console.log(Object.prototype.toString.call([])); // "[object Array]"
console.log(Object.prototype.toString.call({})); // "[object Object]"
console.log(Object.prototype.toString.call('www')); // "[object String]"
console.log(Object.prototype.toString.call(null)); // "[object Null]"
console.log(Object.prototype.toString.call(undefined)); // "[object Undefined]"
console.log(Object.prototype.toString.call(console.log)); // "[object Function]"
```