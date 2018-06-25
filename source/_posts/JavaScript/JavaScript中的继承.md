---
title: JavaScript中的继承
subtitle: js_inherit
tags: [面向对象, JS, 继承]
date: 2017-06-23
categories: JavaScript
description:
---

`继承` 是面向对象语言的重要概念, 许多面向对象编程语言都支持两种继承方式: 接口继承和实现继承. 接口继承只继承方法签名, 而实现继承则继承实际的方法. `JavaScript` 中所有的类其实都是函数, 而函数没有签名, 则无法实现接口继承, 只支持实现继承, 而且实现继承主要是依据原型链来实现的.

<!--more-->

`JavaScript` 中实现继承的方式有很多种, 但都是依赖于原型链,也正是原型链使得整个 `JavaScript` 世界连接在了一起.

下面来具体看看几种常用的继承是如何实现的.

### 1. 原型继承

`原型继承`是JS中最常用的一种继承方式, 子类B想要继承父类A中的所有的属性和方法(私有+公有),只需要让 `B.prototype=new A `即可

`原型继承`的特点：它是把父类中私有的+公有的 都继承到了子类原型上(子类公有的)

```javascript
function A() {
    this.x = 100;
}

A.prototype.getX = function () {
    console.log(this.x);
};

function B() {
    this.x = 200;
}

B.prototype = new A;
B.prototype.constructor = B;
```

`constructor` 是类的原型上很重要的属性, 原型继承方式是重写 `B.prototype` 因此需要手动将 `B.prototype.constructor` 指向 `B`

`核心`：原型继承并不是把父类中的属性和方法克隆一份一模一样的给`B`, 而是让`B`和`A`之间增加了原型链的连接, `B`的实例想要访问和使用`A`中的`getX`方法,需要根据 `原型链查找机制` 进行查找使用

### 2. call继承 

`call继承`：把父类私有的属性和方法 克隆一份 一模一样的 作为子类私有的属性

```javascript
function A() {
    this.x = 100;
}
A.prototype.getX = function () {
    console.log(this.x);
};

function B() {
    A.call(this); // A.call(n) 把A执行让A中的this变为了n
}

var n = new B;
console.log(n.x); // 100
console.log(n.getX); // undefined
```

这种继承方式只是继承了父类中的私有属性给子类的私有属性,父类原型上的公有属性将无法被继承.

### 3. 冒充对象继承

`冒充对象继承`：把父类私有的 + 公有的属性 克隆一份一模一样的 给子类私有的

```javascript
function A() {
    this.x = 100;
}
A.prototype.getX = function () {
    console.log(this.x);
};

function B() {
    var temp = new A;
    for (var key in temp) {
        this[key] = temp[key];
    }
    temp = null;
}

var n = new B;
n.getX(); // 100
```

### 4. 组合模式继承

`组合模式继承`: 原型继承+call继承 混合使用, 将父类的私有属性继承给子类的私有属性, 将父类的实例赋值给子类父类原型.

```javascript
function A() {
    this.x = 100;
}
A.prototype.getX = function () {
    console.log(this.x);
};

function B() {
    A.call(this);
    this.y = 200;
}
B.prototype = new A;
B.prototype.constructor = B;

var n = new B;
n.getX(); // 100
console.log(n.y); // 200
```

这种继承方式避免了 原型继承 和 call继承 的缺陷, 融合了他们的优点, 成为 `JavaScript` 中最常用的继承模式.

### 5. 寄生组合式继承

`寄生组合式继承`: 将父类私有熟悉继承给子类私有,将父类公有继承给子类公有.

```javascript
function A() {
    this.x = 100;
}
A.prototype.getX = function () {
    console.log(this.x);
};

function B() {
    A.call(this);
}
B.prototype = objectCreate(A.prototype);
B.prototype.constructor = B;

var n = new B;
console.dir(n);

//->Object.create(proObj) 创建一个新的对象,但是还要把proObj作为这个对象的原型 在IE6~8不兼容(ECMAScript5)
function objectCreate(o) {
    function fn() {
    }

    fn.prototype = o;
    return new fn;
}
```

### 总结

以上就是 `JavaScript` 中比较常见的几种继承, 实际运用中根据场景需要合理使用, 充分利用各种继承方式的特点.

