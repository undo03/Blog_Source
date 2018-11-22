---
title: 使用webp图片提升前端性能
subtitle: performance_webp
tags: [性能优化, webp]
date: 2018-11-22
categories: 前端新能
---

现在我们看到的大多数网站，80%以上都是图片为主，所以图片的优化是前端性能优化的重要手段，也是非常有必要的一种手段。

我们知道图片的体积越小加载越快，那么图片的优化主要是减小体积或者叫压缩体积，但是压缩体积会造成一定的质量牺牲，那么体积和质量之间怎么均衡呢。
<!--more-->

在进行具体的方案之前先了解一下几种常见格式的图片特征：

### JPEG/JPG

**优点**：JPG 最大的特点是有损压缩。这种高效的压缩算法使它成为了一种非常轻巧的图片格式。另一方面，即使被称为“有损”压缩，JPG的压缩方式仍然是一种高质量的压缩方式：当我们把图片体积压缩至原有体积的 50% 以下时，JPG 仍然可以保持住 60% 的品质。此外，JPG 格式以 24 位存储单个图，可以呈现多达 1600 万种颜色，足以应对大多数场景下对色彩的要求，这一点决定了它压缩前后的质量损耗并不容易被我们人类的肉眼所察觉。

**缺点**：在处理矢量图形或logo等线条感较强、颜色对比强烈的图像时，人为压缩导致图片模糊相当明显。此外jpeg不支持透明，使用很受局限。

**适用场景**： JPG 适用于呈现色彩丰富的图片，开发中，JPG 图片经常作为大的背景图、轮播图。

### PNG-8 与 PNG-24

**优点**：PNG是一种无损压缩的高保真的图片格式。8 和 24，这里都是二进制数的位数，代表了支持的颜色的种类，24位呈现的色彩更丰富。PNG 图片具有比 JPG 更强的色彩表现力，对线条的处理更加细腻，对透明度有良好的支持。

**缺点**： 唯一的 缺点 就是**体积太大**

**使用场景**：logo、小图标、颜色简单、对比度较强的透明小图在 PNG 格式下有着良好的表现。

### SVG

**优点**：**文本文件、体积小、不失真、兼容性好**，SVG 与 PNG 和 JPG 相比，**文件体积更小，可压缩性更强**

**特性**：它和之前提及的其它图片种类有着本质的不同：SVG 对图像的处理不是基于像素点，而是是基于对图像的形状描述。作为矢量图，它最显著的优势还是在于**图片可无限放大而不失真**这一点上。SVG 是文本文件。我们既可以像写代码一样定义 SVG，把它写在 HTML 里、成为 DOM 的一部分，也可以把对图形的描述写入以 .svg 为后缀的独立文件（SVG 文件在使用上与普通图片文件无异）。这使得 SVG 文件可以被非常多的工具读取和修改，具有较强的灵活性。

**缺点**：一方面是它的渲染成本比较高，这点对性能来说是很不利的。另一方面，SVG 存在着其它图片格式所没有的学习成本（它是可编程的）。

### Base64

Base64 并非一种图片格式，而是一种编码方式。Base64 和雪碧图一样，是作为小图标解决方案而存在的。

雪碧图、CSS 精灵、CSS Sprites、图像精灵，说的都是这个东西——一种将小图标和背景图像合并到一张图片上，然后利用 CSS 的背景定位来显示其中的每一部分的技术，大家都非常熟悉了。

雪碧图的出现是为了从另一个方面进行性能的提升，减少网页图片对服务器的请求次数。

Base64同样也是为了减少请求次数，降低http的开销。

**Base64 是一种用于传输 8Bit 字节码的编码方式，通过对图片进行 Base64 编码，我们可以直接将编码结果写入 HTML 或者写入 CSS，从而减少 HTTP 请求的次数。**

但是打开一些主流网站我们发现Base64码出现的次数很少，这是因为Base64 编码后，编码的大小会膨胀为原图片的 4/3（这是由 Base64 的编码原理决定的）。如果我们把大图也编码到 HTML 或 CSS 文件中，后者的体积会明显增加，即便我们减少了 HTTP 请求，也无法弥补这庞大的体积带来的性能开销，得不偿失。

因此，通常我们在开发的时候一般只会将体积非常小的图片进行Base64编码，这个时候Base64 带来的文件体积膨胀、以及浏览器解析 Base64 的时间开销，与它节省掉的 HTTP 请求开销相比，可以忽略不计，这时候才能真正体现出它在性能方面的优势。

在webpack盛行的情况下，只需要在[url-loader](https://link.juejin.im/?target=https%3A%2F%2Fgithub.com%2Fwebpack-contrib%2Furl-loader)中稍加配置就可以将一定体积之下的图片编译成Base64码。也有很多线上的编码工具可供使用。

### WebP

WebP 于 2010 年被提出， 是 Google 专为 Web 开发的一种**旨在加快图片加载速度**的图片格式，它支持有损压缩和无损压缩。它集多种图片文件格式的优点于一身。

> 与 PNG 相比，WebP 无损图像的尺寸缩小了 26％。在等效的 SSIM 质量指数下，WebP 有损图像比同类 JPEG 图像小 25-34％。 无损 WebP 支持透明度（也称为 alpha 通道），仅需 22％ 的额外字节。对于有损 RGB 压缩可接受的情况，有损 WebP 也支持透明度，与 PNG 相比，通常提供 3 倍的文件大小。

这也许是目前图片优化的最佳方式了。

可是万恶的兼容性让他的使用受到了局限。

![1542164268396](http://img13.360buyimg.com/uba/jfs/t29299/214/484992014/43062/361fdad1/5bf4cce8Na40450ed.png)

此外，WebP 还会增加服务器的负担——和编码 JPG 文件相比，编码同样质量的 WebP 文件会占用更多的计算资源。

webp的应用场景：限制我们使用 WebP 的最大问题不是“这个图片是否适合用 WebP 呈现”的问题，而是“浏览器是否允许 WebP”的问题，即我们上文谈到的兼容性问题。当我们选择适用webp图片，就要考虑在不支持它的浏览器下如何正常显示。

webp图片方案已经被多数大厂应用到项目中，比如在Chrome中打开京东首页，我们查看网络发现他们也使用了很多的webp格式的图片。

![1542852435559](http://img13.360buyimg.com/uba/jfs/t28183/42/537026357/77280/842d1df/5bf60f8dN2042b016.png)

再来查看元素，我们发现html是这样的

```html
<img src="//img13.360buyimg.com/mobilecms/s140x140_jfs/t1/4688/27/2880/248823/5b978fe4Eeea92074/5c1ee7f70e8855e9.jpg!q90.webp" class="lazyimg_img">
```

而在IE浏览器中打开，它的html却是这样的

```html
<img class="lazyimg_img" src="//img13.360buyimg.com/mobilecms/s140x140_jfs/t1/4688/27/2880/248823/5b978fe4Eeea92074/5c1ee7f70e8855e9.jpg!q90">
```

我们发现支持webp的浏览器中图片的url地址多了 `.webp`后缀，而.webp 前面，还跟了一个 .jpg 后缀！

可以大胆地猜测，这个图片应该至少存在 jpg 和 webp 两种格式，程序会根据浏览器的型号、以及该型号是否支持 WebP 这些信息来决定当前浏览器显示的是 .webp 后缀还是 .jpg 后缀。

那基于这种猜测我们怎么实现呢？

### 根据webp支持度决定请求那种格式的图片

首先要检测浏览器是否支持webp，下面是网上比较通用的方式。

```javascript
 ;(function(doc) {
     // 给html根节点加上webps类名
     function addRootTag() {
         doc.documentElement.className += "webps";
     }
     // 判断是否有webps=A这个cookie
     if (!/(^|;\s?)webps=A/.test(document.cookie)) {
         var image = new Image();
         // 图片加载完成时候的操作
         image.onload = function() {
             // 图片加载成功且宽度为1，那么就代表支持webp了，因为这张base64图是webp格式。如果不支持会触发image.error方法
             if (image.width == 1) {
                 // html根节点添加class，并且埋入cookie
                 addRootTag();
                 document.cookie = "webps=A; max-age=31536000; domain=58.com";
             }
         };
         // 一张支持alpha透明度的webp的图片，使用base64编码
         image.src = 'data:image/webp;base64,UklGRkoAAABXRUJQVlA4WAoAAAAQAAAAAAAAAAAAQUxQSAwAAAARBxAR/Q9ERP8DAABWUDggGAAAABQBAJ0BKgEAAQAAAP4AAA3AAP7mtQAAAA==';
     } else {
         addRootTag();
     }
 }(document));
```

把这段js代码在引入css之前加载进来，如果浏览器支持webp则会给html元素添加webps这个类名。

接下来在css中如何使用呢，上面在在html元素加了webps这个类，那么在这个类下的元素就可以使用webp格式图片了 。

比如 

```css
.webp-bg {
    width: 620px;
    height: 304px;
    background-image: url(assets/img/iweb.png);
}
.webps .webp-bg {
    background-image: url(assets/img/iweb.png.webp);
}
```

如果使用了less或sass则更加简单，效率更高

```less
// less
.mixin(@url) {
  background-image: url(@url);
  .webps & {
      background-image: url('@{url}.webp');
  }
}

.webp-bg {
  width: 620px;
  height: 304px;
  .mixin('../../asset/img/iweb.png')
}
```

定义一个函数，函数中处理图片格式的兼容，在背景图片使用的地方使用函数即可

sass中实现同理

```less
@mixin bg($url) {
    background-image: url($url);
    @at-root(with: all) .webps & {
        background-image: url($url + '.webp');
    }
}
```

那么img标签的url需要检测 document.documentElement.className 中是否包含 webps来决定是否在url后面追加 .webp 

这种方式在调试的时候就需要准备好webp图片，那么怎么得到webp图片呢 ？

webp图片可以去网站平台或者格式转换工具生成，但是每次都手动去转换显然是很繁琐效率低下的事情，在node中我们可以使用文件系统检测文件的变化，从而根据变化动态生成webp图片。

实现上述功能需要用到 chokidar 和 webp-converter

chokidar 可以用于监控文件、文件夹变化，我们可以传入 glob 文件匹配模式，并可以简单实现递归目录监控。chokidar 可以监控各种文件、文件夹变化事件，包含 `add` , `change` , `unlink` , `addDir` , `unlinkDir` 等。

webp-converter 是个webp转换器，用来将图片转换成webp格式，或者由webp转换成其他格式。

上述功能简单实现如下：

```javascript
const chokidar = require('chokidar')
const fs = require('fs')
const webp = require('webp-converter')

const imgDir = 'img'
const ignoreFiles = /(^\..+)/ // 忽略文件.开头

const Watcher = chokidar.watch(imgDir, {
  ignored: path => ignoreFiles.test(path),
  persistent: true
}) 

Watcher.on('all', (event, path) => {
  // console.log('event:', event, 'path:', path)
  switch (event) {
    // add change unlink 
    case 'add': 
    case 'change':
      createWebp(path)
      break
    case 'unlink': 
      deleteImage(path)
    default:
      return
  }
})

const deleteImage = path => {
  let imgPath = ''
  if(/\.webp$/.test(path)) {
    imgPath = path.substr(0, path.lastIndexOf('.'))
  } else {
    imgPath = path + '.webp'
  }
  if (fs.existsSync(imgPath)) {
    fs.unlinkSync(imgPath)
  }

}

const createWebp = path => {
  if(/\.webp$/.test(path)) return
  if(fs.existsSync(path + '.webp')) return
  webp.cwebp(path, path + '.webp', '-q 75', (status) => {
    console.log(status)
  })
}

```

这种方式需要在node环境中运行这个js文件，来检测文件夹变化，可以是一个文件夹，也可以检测多个文件夹的变化，后续可以考虑做成webpack插件，以便在工程化项目中更方便的使用。

这样我们就可以在开发调试的时候就使用上webp图片，这种方式更容易控制，但是管理起来更加繁琐。

下面介绍一种结合 Service Workers 的一种实现方案。

### Service Workers 动态响应webp图片

Service Workers 同样也是比较新的技术，兼容性也不是很好，但是这个也是提升前端性能的重要途径，充分体现优雅降级，在支持它的浏览器中性能表现更为优异，不兼容的继续采用之前的方式。

![1542249884726](http://img14.360buyimg.com/uba/jfs/t28330/227/470674840/52834/9532d0e2/5bf4cce8N62374093.png)



这种方式的的操作比较简单，在项目中的入口html文件中加入以下代码，用于注册Service Worker。

```javascript
// Register the service worker
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('./service-worker.js').then(function(registration) {
        // Registration was successful
        console.log('ServiceWorker registration successful with scope: ', registration.scope);
    }).catch(function(err) {
        // registration failed :(
        console.log('ServiceWorker registration failed: ', err);
    });
}

```

如果浏览器支持Service Workers 以上代码就会执行，不支持也不会影响项目的正常运行，用户其实是无感知的.

然后创建Service Worker文件`service-worker.js`，用于拦截正在传递到服务器的请求。

```javascript
// service-worker.js
"use strict";
self.addEventListener('fetch', function (event) {
  if (/\.jpe?g$|\.png$/.test(event.request.url)) {
    var supportsWebp = false;
    if (event.request.headers.has('accept')) {
      supportsWebp = event.request.headers.get('accept').includes('webp');
    }
    if (supportsWebp) {
      var req = event.request.clone();
      var returnUrl = req.url + '.webp'
      event.respondWith(
        fetch(returnUrl, {
          mode: 'no-cors'
        })
      );
    }
  }
});
```

Service Worker 服务注册成功之后，给他添加事件监听，监听所有的fetch事件，fetch事件会拦截所有的请求，当请求发生时，先判断请求是否是请求的`JPEG/JPG/PNG`格式的图片，然后再通过查看请求头中的`accept`字段，检测是否支持`webp`格式的图片，支持的话Accept中存在`image/webp` Mime类型，如果支持则替换成webp图片的url，去请求webp图片，不支持则正常请求 `JPEG/JPG/PNG` 格式的图片。

![1542250706599](http://img13.360buyimg.com/uba/jfs/t25861/343/2406676566/32025/6d85f77f/5bf4cce8N1317770b.png)

然后来看一下实际的效果，



![1542250793076](http://img13.360buyimg.com/uba/jfs/t27808/334/1995427189/4031/741665ad/5bf4cce8N1537074a.png)

html中是去加载这张png格式的图片，然而我们看看实际的网络请求状况：

![1542250942374](http://img30.360buyimg.com/uba/jfs/t28849/219/479875041/14062/53449c0f/5bf4cce7N88d43324.png)

这就是 Service Worker 的功劳，我们代码中只是需要 png格式图片，Service Worker 却给我们返回了 webp 格式的图片，再回顾一下 webp 格式图片的特点，相同质量下的图片 webp 比 png 小 26%，如果页面中有大量图片的话，带来的性能优化和节省的网络流量还是相当可观的。

Service Worker 的功能很强大，不仅可以拦截网络请求，还能进行缓存等更强大的功能，所以合理的运用它会给我们的web性能带来更为显著的提升。

Service Worker 只有在https协议下才能注册成功，因此这种方式仅仅只需要解决线上环境的优化处理，在项目开发阶段无需关心，也就是说我们在开发阶段可以不用考虑webp图片的兼容问题，代码中所有图片都使用常用格式图片。

那么现在又有一个问题，这些webp格式的图片怎么出现在线上服务器呢？

有一些线上工具可以进行图片格式的转换，可以寻找到一些解决方案，也可以使用一些插件工具比如谷歌官方的webp生成工具，安装通过命令生成图片，然后将webp格式图片和常用格式图片一并上传至服务器。

现在webpack已经成为前端开发者项目工程化比不可少的工具了，其实在webpack中配置响应的规则就可以自动化的生成webp的图片，同时配合 url-loader 将一些很小的图片转成 base64 进一步减少图片带来的网络请求。

说webpack 配置之前先说一个 loader --  multi-loader，它的主要作用简单来说就是同一规则进行了同时用多个loader进行加载编译，同时输出对应的文件或结果。

那么在 webpack 项目中我们可以只需要将png、jpg、jpeg等常见格式的图片引入项目中，所有的图片地址正常操作，在打包编译的时候，编译输出两张不同格式的图片即可，一张 webp 的，一张常规格式的。

```javascript
const multi = require('multi-loader');
...
// 图片加载规则
	{
        test: /\.(jpg|png|gif|jpeg)$/,
        use: [

            {
                loader: multi(
                    'url-loader?limit=8192&name=assets/img/[name].[ext].webp!webp-loader?{quality: 75}',
                    'url-loader?limit=8192&name=assets/img/[name].[ext]'
                )
            }
        ],
    },
...
```

稍作解释，用 url-loader 加载图片，对于小于8kb（大小根据项目而定）的图片进行base64编码；对于大于8kb的图片，编译出正常常规的图片，同时再使用 webp-loader 编译出一张 webp 格式的图片， webp-loader 可以传参数 quality 代码图片的转码的质量，相当于进一步压缩，压缩出来的图片webp 的大小不到原始图片的一半。

然后配合上面的 service worker工作量很小，但是带来的性能优化却是很可观的。

上面这种方式确实可以实现从服务器动态加载webp格式的图片，但是我们发现这样去使用的话仅仅只是需要对项目中的静态图片进行拦截，而相关业务的图片加载并不需要拦截，或许服务器上根本就没有配置webp格式的图片，比如接口中返回的图片地址。因此需要对代码稍作调整，对项目开发中的静态图片地址加参数，在 service worker 中匹配图片格式和参数，从而避免一些不必要的拦截。

```javascript
// service-worker.js
"use strict";
self.addEventListener('fetch', function (event) {
  if (/(\.jpe?g|\.png)\?iswebp$/.test(event.request.url)) {
    var supportsWebp = false;
    if (event.request.headers.has('accept')) {
      supportsWebp = event.request.headers.get('accept').includes('webp');
    }
    if (supportsWebp) {
      var req = event.request.clone();
      var returnUrl = req.url.substr(0, req.url.lastIndexOf("?")) + ".webp";
      // var returnUrl = req.url + '.webp'
      event.respondWith(
        fetch(returnUrl, {
          mode: 'no-cors'
        })
      );
    }
  }
});
```

webpack 配置中也做一下调整，是打包出来的图片路径拼接上参数。

```javascript
const multi = require('multi-loader');
...
	{
        test: /\.(jpg|png|gif|jpeg)$/,
        use: [

            {
                loader: multi(
                    'url-loader?limit=8192&name=assets/img/[name].[ext].webp!webp-loader?{quality: 75}',
                    'url-loader?limit=8192&name=assets/img/[name].[ext]?iswebp'
                )
            }
        ],
    },
...
```

这样就可以只对图片 url 中以 .iswebp结尾的请求进行拦截请求webp格式的图片，如果浏览器不支持，就会正常请求相应格式的图片。

这样做有个好处，除了静态资源上的图片可以这样处理以外，其他动态的接口图片地址根据实际情况也可以实现使用 webp ，因为仅仅只需要在图片url上加上iswebp标识，服务器有对应的webp图片即可。

这种方案更简单适用性更强，结合 Service Worker 性能上的提升会非常明显。

更多关于  Service Worker  的文档请移步 [ https://lavas.baidu.com/](https://lavas.baidu.com/)

**结语**：webp 格式图片现在呗越来越多的浏览器支持，它小体积高质量的特点使得它越来越受欢迎，我们可以在我们的项目中多使用它，利用它提升前端性能，同时也节省网络流量，webp只是解决方案之一，有更多更好的方案值得我们继续探索。webp 好用但也不是处处可用，项目中根据实际的业务场景和图片特性选择合理的图片格式才能真正体现它们的价值。