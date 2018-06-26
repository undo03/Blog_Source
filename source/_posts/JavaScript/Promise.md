---
title: Promise 简单介绍
subtitle: js_promise
tags: [promise, ES6, JS]
date: 2018-06-22
categories: JavaScript
description:
---

`Promise `对于每一个前端工程师来说都不陌生,在项目开发中的使用也是越来越频繁,各大主流浏览器厂商也是对它做了很好的支持. Promise的出现解决了回调地狱的问题, 同时多个异步任务同时执行可以节省时间.

<!--more-->

### 1. Promise简介

`Promise`本意是承诺，在程序中的意思就是承诺我`过一段时间后`会给你一个结果。 什么时候会用到过一段时间？答案是异步操作，异步是指可能比较长时间才有结果的才做,常见的比如网络请求、文件读取等.

传统的异步操作都是传回调函数,异步完成后执行回调,`promise`就是为了改变这种模式,把异步中使用回调函数的场景改为了`.then()`、`.catch()`等函数链式调用的方式,避免回调地狱,基于`promise`可以把复杂的异步回调处理方式进行模块化.

以`ajax`为例,传统的异步写法:

```javascript
ajax(method, url, successFun, failFun){
  var xmlHttp = new XMLHttpRequest()
  xmlHttp.open(method, url)
  xmlHttp.send()
  xmlHttp.onload = function () {
    if (this.status == 200 ) {
      successFun(this.response)
    } else {
      failFun(this.statusText)
    }
  }
  xmlHttp.onerror = function () {
    failFun(this.statusText)
  }
}
```

尝试改写成`promise`的方式

```javascript
ajaxPromise(method, url, successFun, failFun){
  return new Promise(function(resolve, reject){
    var xmlHttp = new XMLHttpRequest()
    xmlHttp.open(method, url)
    xmlHttp.send()
    xmlHttp.onload = function () {
      if (this.status == 200 ) {
        resolve(this.response)
      } else {
        reject(this.statusText)
      }
    }
    xmlHttp.onerror = function () {
      reject(this.statusText)
    }
  })
}

```

然后就可以链式使用了

```javascript
ajaxPromise('get','www.xxx.com').then(successFun, failFun)
```

### 2. Promise原理分析

`promise`原理并不难,它内部有三个状态，分别是`pending`,`fulfilled`和`rejected` .

- `Pending` Promise对象实例创建时候的初始状态
- `Fulfilled` 可以理解为成功的状态
- `Rejected` 可以理解为失败的状态

`pending`是对象创建后的初始状态,当对象`fulfill（成功）`时变为`fulfilled`,当对象`reject（失败）`时变为`rejected`.且只能从`pengding`变为`fulfilled`或`rejected`,之后就不会再次发生变化 ,不能逆向或从`fulfilled`变为`rejected` 、从`rejected`变为`fulfilled`.

> `then` 方法就是用来指定`Promise `对象的状态改变时确定执行的操作,`resolve` 时执行第一个函数`onFulfilled`,`reject` 时执行第二个函数`onRejected`

### 3. Promise 简单模拟

```javascript
class Promise {
    constructor(fn) {
        fn((data)=> {
            this.success(data)
        }, (error)=> {
            this.error()
        })
    }

    resolve(data) {
        this.success(data)
    }

    reject(error) {
        this.error(error)
    }

    then(success, error) {
        this.success = success
        this.error = error
    }
}
```

### 4. Promise基本用法

`Promise`对象拥有两个实例方法`then()`,`catch()` 和 `finally`,`then`方法返回新的`promise`,因此支持链式写法

```javascript
let promise = new Promise((resolve, reject) => {
    let flag = Math.random()
    setTimeout(() => {
        if(flag > 0.5) {
            resolve('success')
        }
        else {
            reject('fail')
        }
    }, 500)
})

promise.then((result) => {
    console.log(result)
}, (err) => {
    console.log(err)
}) // 0.5s后这里的输出可能是fail也可能是success

```

构造函数`Promise`的参数时一个函数,这个函数接收来两个参数`resolve`和`reject`,`resolve`和`reject`同时也是函数,`resolve`会在`promise`从`pending`转换成 `Fulfilled`时执行, `reject`会在`promise`从`pending`转换成 `Rejected`时执行.

#### 4.1 Promise.prototype.catch()

`then()`方法会返回一个新的`promise`,`then`方法将上一步的返回结果获取过来进行后续的处理,它接受两个函数作为参数，第一个函数是用来处理`resolve`的结果，第二个是可选的，用来处理`reject`的结果,`then`对应的参数不为函数时,会将前一`promise`的状态和值传递下去.

```javascript
let p = new Promise((resolve, reject) => {
    reject(5)
})
let p1 = p.then((value) => {
    console.log(value) 
})
let p2 = p1.then((value) => {
    console.log('fulfill ' + value)
}, (reason) => {
    console.log('reject ' + reason)   // reject 5
})
```

```javascript
let p = new Promise((resolve, reject) => {
    resolve(5)
})
let p1 = p.then(undefined, (value) => {
    console.log(value) 
})
let p2 = p1.then((value) => {
    console.log('fulfill ' + value)   // fulfill 5
}, (reason) => {
    console.log('reject ' + reason)   
})
```

#### 4.2 Promise.prototype.catch()

`catch()`方法其实是`then`方法的一种语法糖,当`then`方法第一个参数传`undefined` 或者 `null`即可达到`catch`的目的

```javascript
let promise = new Promise((resolve, reject) => {
    let flag = Math.random()
    setTimeout(() => {
        if(flag > 0.5) {
            resolve('success')
        }
        else {
            reject('fail')
        }
    }, 500)
})

// then处理resolve和reject的结果
promise.then((result) => {
    console.log(result)
}, (err) => {
    console.log(err)
})

// then处理resolve,catch处理reject的结果
promise.then((result) => {
    console.log(result)
}).catch( (err) => {
    console.log(err)
})

// 用then的方式实现catch功能
promise.then((result) => {
    console.log(result)
}).then(null, (err) => {
    console.log(err)
})

// 用then的方式实现catch功能,捕获then中的错误异常
promise.then((result) => {
    console.log(result)
    throw new Error('then Error')
}).then(null, (err)=>{
    console.log(err)
})
```

#### 4.3 Promise.prototype.finally()

`finally()` 方法返回一个`Promise`,在执行`then()`和`catch()`后,都会执行`finally`指定的回调函数.避免同样的语句需要在`then()`和`catch()`中各写一次的情况.

`finally()` 虽然与 `.then(onFinally, onFinally)` 类似,它们不同的是:

* 调用内联函数时,不需要多次声明该函数或为该函数创建一个变量保存它.
* 由于无法知道`promise`的最终状态,所以`finally`的回调函数中不接收任何参数,它仅用于无论最终结果如何都要执行的情况.
* 与`Promise.resolve(2).then(() => {}, () => {})` （`resolved`的结果为`undefined`）不同,`Promise.resolve(2).finally(() => {})` `resolved`的结果为 `2`.
* 同样,`Promise.reject(3).then(() => {}, () => {})` (`resolved` 的结果为`undefined`), `Promise.reject(3).finally(() => {})` rejected 的结果为 `3`.

### 5. Promise  API

`Promise`还有四个静态方法，分别是`resolve`、`reject`、`all`、`race`,下面一一介绍.

除了通过`new Promise()`的方式，我们还有两种创建`Promise`对象的方法,分别是`Promise.resolve()` 和 `Promise.reject()`

#### 5.1 Promise.resolve

`Promise.resolve()` 它相当于创建了一个立即`resolve`的`promise`对象,这个对象处于`resolve`状态

```javascript
let p1 = Promise.resolve('resolve')

let p2 = new Promise((resolve) => {
    resolve('resolve')
})

p1.then(res => {
    console.log(res) // resolve
})
p2.then(res => {
    console.log(res) // resolve
})
```
#### 5.2 Promise.reject

`Promise.reject()` 很明显它相当于创建了一个立即`reject`的`promise`对象,这个对象处于`reject`状态

```javascript
Promise.reject('err').catch(err => {
    console.log(err) // err
})
```

#### 5.3 Promise.all

`Promise.all()` 它接收一个promise对象组成的数组作为参数，并返回一个新的`promise`对象

当数组中所有的对象都`resolve`时，`promise`对象状态变为`fulfilled`，所有对象的`resolve`的`value`依次添加组成一个新的数组，并以新的数组作为新`promise`对象`resolve`的`value`

```javascript
Promise.all([Promise.resolve('p1'),
    Promise.resolve('p2'),
    Promise.resolve('p3')]).then((value) => {
    console.log('fulfill', value)  // fulfill [ 'p1', 'p2', 'p3' ]
}, (reason) => {
    console.log('reject',reason)
})
```

当数组中有一个对象`reject`时，`promise`对象状态变为`rejected`，并以当前对象`reject`的`reason`作为新`promise`对象`reject`的`reason`

当数组中传入了非promise对象,会依次把它们添加到新`promise`对象`resolve`时传递的数组中.

```javascript
Promise.all([Promise.resolve(5),
    6,
    true,
    'test',
    undefined,
    null,
    {a:1},
    function(){},
    Promise.resolve('end')
]).then((value) => {
    console.log('fulfill', value)  // fulfill [ 5, 6, true, 'test', undefined, null, { a: 1 }, [Function], 'end' ]
}, (reason) => {
    console.log('reject', reason)
})
```

数组中的多个`promise`对象几乎是同时执行的,总的时间略大于用时最长的一个对象`resolve`的时间

```javascript
let timeout = (time) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve(time)
        }, time)
    })
}
console.time('promise')
Promise.all([
    timeout(10),
    timeout(60),
    timeout(100)
]).then((values) => {
    console.log(values) //[10, 60, 100]
    console.timeEnd('promise')   // promise: 101.875ms
})
```

`Promise.all()`中即使前面`reject`了,所有的对象也都会执行完毕.规范中`promise`对象执行是不可以中断的.

#### 5.4 Promise.race

`Promise.race()` 它同样接收一个`promise`对象组成的数组作为参数,并返回一个新的`promise`对象

与`Promise.all()`不同的是,它是在数组中有一个对象（最早改变状态）`resolve`或`reject`时,就改变自身的状态,并执行相应的回调.

```javascript
let timeout = (time) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve(time)
        }, time)
    })
}
console.time('promise')
Promise.race([
    timeout(10),
    timeout(60),
    timeout(100)
]).then((values) => {
    console.log(values); [10, 60, 100]
    console.timeEnd('promise');   // promise: 11.330ms
})

Promise.race([timeout(10), timeout(60), Promise.reject('error')])
.then((values) => {
    console.log(values)
}).catch(err=>{
    console.log(err) // error
})
```

当数组中有非异步`Promise`对象或有数字、boolean、字符串、undefined、null、{a:1}、function(){}等非`Promise`对象时，都会直接以第一个值`resolve`,立即改变为`Fulfilled`状态

注意:

> `promise`对象即使立马改变状态,它也是异步执行的

```javascript
Promise.resolve(5).then((value) => {
    console.log('test', value)
})
console.log('先打出来')

// 先打出来
// 后打出来 5
```