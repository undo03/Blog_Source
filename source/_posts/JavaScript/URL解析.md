---
title: URL解析
subtitle: URL_Analysis
tags: [JS]
date: 2019-07-02
categories: JavaScript
description:
---

今天上班前的几分钟在掘金上看到一篇文章在讲“有趣的JS特性”,文中讲到利用JS特性解析url,于是乎学习一下做下记录。

我们为什么需要解析`url`呢,一版来说,我们需要从`url`中提取某些重要信息,比如从`url`中提取`host`、`origin`、`pathname`、`protocol`、`search`等信息。

<!--more-->

### 1. window.location

针对获取当前页面`url`地址的情况，使用`window.location`或许是最简单直接的方式了。

```JavaScript
console.log(window.location);
// Location {replace: ƒ, href: "https://juejin.im/post/5d1716e4f265da1bbc6fea1e?utm_source=gold_browser_extension", ancestorOrigins: DOMStringList, origin: "https://juejin.im", protocol: "https:", …}
// ancestorOrigins: DOMStringList {length: 0}
// assign: ƒ assign()
// hash: ""
// host: "juejin.im"
// hostname: "juejin.im"
// href: "https://juejin.im/post/5d1716e4f265da1bbc6fea1e?utm_source=gold_browser_extension"
// origin: "https://juejin.im"
// pathname: "/post/5d1716e4f265da1bbc6fea1e"
// port: ""
// protocol: "https:"
// reload: ƒ reload()
// replace: ƒ ()
// search: "?utm_source=gold_browser_extension"
// toString: ƒ toString()
```
我们基本可以获取到我们常用的所有信息，只是查询字符串需要我们手动解析。

### 2. 利用a标签解析 url

这种方案是我今天在掘金上看到的，这个方案是利用了a标签的特性，给href属性赋值url，就可以解析url获得我们想要的信息字段。

相比于第一种方式，这种可以解析任意的url地址。

```JavaScript
function parseURL(url) {
    var a =  document.createElement('a');
    a.href = url;
    console.log(a);
    return {
        host: a.hostname,
        port: a.port,
        query: a.search,
        hash: a.hash.replace('#','')
    };
}
```
打印创建出来的a标签，可以看到a作为dom元素的所有属性，以及url解析后的字段，字段包含 window.location 解析出来的字段。

但是如果需要解析查询字符串，还是需要手动解析。

### 3. new URL()

还新学习到一种解析 url 的方法。 `URL()` 构造函数返回一个新创建的 `URL` 对象，表示由一组参数定义的 URL。

```JavaScript
    let url = new URL(url, [base])
```

**url**: 是一个表示绝对或相对 URL 的 DOMString。如果url 是相对 URL，则会将 base 用作基准 URL。如果 url 是绝对URL，则将忽略 base，无论是否有给出。
**base**: 可选，是一个表示基准 URL 的 DOMString，在 url 是相对 URL 时，它才会起效。如果未指定，则默认为''。

```JavaScript
    let url = new URL('https://juejin.im/post/5d1716e4f265da1bbc6fea1e?utm_source=gold_browser_extension');
    console.log(url);
    // hash: ""
    // host: "juejin.im"
    // hostname: "juejin.im"
    // href: "https://juejin.im/post/5d1716e4f265da1bbc6fea1e?utm_source=gold_browser_extension"
    // origin: "https://juejin.im"
    // password: ""
    // pathname: "/post/5d1716e4f265da1bbc6fea1e"
    // port: ""
    // protocol: "https:"
    // search: "?utm_source=gold_browser_extension"
    // searchParams: URLSearchParams {}
    // username: ""
```

可以看到也能正常解析url，但注意观察，生成的 url 对象中多了一个 `searchParams` 属性，它的值是 `URLSearchParams`，它是干什么的呢？

翻看 MDN ，它是这样描述的
> URLSearchParams 接口定义了一些实用的方法来处理 URL 的查询字符串。

没错就是用来操作url的查询字符串的，它拥有很强大的功能，可以对查询字符串进行查询、获取、设置、排序等操作。

```JavaScript
    console.log(URLSearchParams.prototype);
    // append: ƒ append()
    // delete: ƒ delete()
    // entries: ƒ entries()
    // forEach: ƒ forEach()
    // get: ƒ ()
    // getAll: ƒ getAll()
    // has: ƒ has()
    // keys: ƒ keys()
    // set: ƒ ()
    // sort: ƒ sort()
    // toString: ƒ toString()
    // values: ƒ values()
```
具体API的使用查看文档既可，这为从url中获取查询字符串中的信息带来了极大的方便。

另外，在使用 `new URL()` 的时候有几点需要注意，先看下面几个例子。

```JavaScript
    var a = new URL("/", "https://developer.mozilla.org"); // Creates a URL pointing to 'https://developer.mozilla.org/'
    var b = new URL("https://developer.mozilla.org");      // Creates a URL pointing to 'https://developer.mozilla.org/'
    var c = new URL('en-US/docs', b);                      // Creates a URL pointing to 'https://developer.mozilla.org/en-US/docs'
    var d = new URL('/en-US/docs', b);                     // Creates a URL pointing to 'https://developer.mozilla.org/en-US/docs'
    var f = new URL('/en-US/docs', d);                     // Creates a URL pointing to 'https://developer.mozilla.org/en-US/docs'
    var g = new URL('/en-US/docs', "https://developer.mozilla.org/fr-FR/toto");
                                                        // Creates a URL pointing to 'https://developer.mozilla.org/en-US/docs'
    var h = new URL('/en-US/docs', a);                     // Creates a URL pointing to 'https://developer.mozilla.org/en-US/docs'
    var i = new URL('/en-US/docs', '');                    // Raises a TypeError exception as '' is not a valid URL
    var j = new URL('/en-US/docs');                        // Raises a TypeError exception as '/en-US/docs' is not a valid URL
    var k = new URL('http://www.example.com', 'https://developers.mozilla.com');
                                                        // Creates a URL pointing to 'http://www.example.com/'
    var l = new URL('http://www.example.com', b);          // Creates a URL pointing to 'http://www.example.com/'
```

不难发现以下规律：
- 最终生成的 url = url || base 的 origin + url
- url 和 base 都缺少 origin、host 等信息的时候会报错
- url具备完整url信息的时候base会失效

关于查询字符串的解析，实现的方式很多，这里不多说了。
