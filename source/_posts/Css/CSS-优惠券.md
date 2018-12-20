---
title: CSS - 实现优惠券
subtitle: css_coupon
tags: [CSS, 优惠券, CSS-clip]
date: 2018-12-20
categories: CSS
description:
---



最近在项目开发中遇到一个优惠券需求，与常见的优惠券类似，中部有反向的圆角。

![1542164268396](https://raw.githubusercontent.com/undo03/Blog_Source/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181220100120.png)

类似于这样的优惠券，在开发中如何去实现呢。
<!--more-->

#### 1. 使用背景图

我们遇到这样的需求，第一反应可能是使用背景图，要一张白底的带内圆角的背景图，就像下面这样：

![1542164268396](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181220101203.png?raw=true)

这样当然没有问题，简单，方便，没有兼容性问题，即使在低版本的IE中也没有丝毫的问题，但是如果不考虑低版本浏览器，不考虑兼容性的话，使用css来实现会更好。

1. 使用css易于控制，如设计有改尺寸，我们只需要更改部分代码就能实现
2. 不使用图片，减少网络请求，css实现加载起来更快

#### 2. 使用css，内圆角背景与底色一样

如果优惠券的底色是个纯色的，那么其实可以考虑这种很简便的实现方式，即使用两个圆角，背景色与底色相同即可。

```html
<div class="wrapper1">
    <div class="coupon"></div>
</div>
```

```css
.wrapper1 {
  width: 750px;
  height: 250px;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #EA364B;
}

.wrapper1 .coupon {
  width: 710px;
  height: 220px;
  overflow: hidden;
  background: #ffffff;
  border-radius: 8px;
  position: relative;
}

.wrapper1 .coupon::before, .wrapper1 .coupon::after {
  content: '';
  position: absolute;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: #EA364B;
}

.wrapper1 .coupon::before {
  top: -15px;
  left: 520px;
}
.wrapper1 .coupon::after {
  bottom: -15px;
  left: 520px;
}
```

这样就能实现以上的效果，但是这样有一个弊端，伪元素before和after，的背景色必须与外层容器的背景色保持一致，而当外层背景色改变或者是渐变的那就会出现无法避免的问题，伪元素的背景色不能与外层背景色很好的衔接。

所以最理想的状态是内圆角的背景色是透明的即可避免。

这种方式由于本身背景色是白色，即使伪元素的背景使用 transparent 也会展示成白色，并不能穿透这层白色的背景。

#### 3. 使用css，背景剪切clip

为了实现上面的透明圆角，将优惠券从向内的圆角的中心处分为左右两部分。为了效果明显右半部分先用黑色。

```html
  <div class="coupon">
    <div class="coupon-left"></div>
    <div class="coupon-right"></div>
  </div>
  <style>
    .coupon {
      width: 710px;
      height: 220px;
      border-radius: 8px;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .coupon-left {
      width: 520px;
      height: 220px;
      background: #ffffff;
    }
    .coupon-right {
      width: 190px;
      height: 220px;
      background: #252525;
    }
  </style>
```
![1542164268396](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20181220104352.png?raw=true)

下面就来实现中间看着比较复杂的"凹槽"部分

我能想到跟圆角相关的有圆角、圆形、径向...这些吧

有人说`svg`也可以，确实`svg`什么都可以做，不光是这种形状，只要画个路径，填充一下就完事，这个比较通用，并不是这个特例，所以在这里不讨论用这个方式。
还有一个原因，`svg`生成的形状也是固定了的，只能等比缩放，不能做其他自适应了。

##### 实现圆角

可以先实现一个圆形，背景色默认透明，设置边框，即可得到一个圆形。

加入将圆的边框设的很大，外层容器超出隐藏就可以得到我们想要的效果。

![1111111](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/4563335-5b515f00da666_articlex.jpg?raw=true)  ![2222222](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/881250682-5b515f00719e0_articlex.jpg?raw=true)  ![3333333](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/1153531229-5b515f006f297_articlex.jpg?raw=true)

有了以上的思路我们就可以实现我们的需求了，先实现左边，修改css， 去掉原来的背景色，用边框来实现。

```css
.coupon-left {
    width: 520px;
    height: 220px;
    position: relative;
    /* background: #fff; */
    overflow: hidden;
}
.coupon-left::before {
    content: '';
    position: absolute;
    right: -575px;
    top: -575px;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    border: 560px solid #fff;
}  
```

![444444444](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20181220110106.png?raw=true)

这样就实现了一个右上角的内圆弧，继续按照这个思路实现after元素，定位到右下角，这时候我们发现出现了问题，before元素覆盖了整个的盒子，把右下角的圆角给挡住了。

这里我们可以使用clip属性来裁剪背景，只需要before占据盒子的上半部分，after占据盒子的下班部分。

关于`clip`这里简单介绍一下，我们一般会用到`rect`这个功能，有四个值，分别是上右下左。

```css
clip: rect(<top>, <right>, <bottom>, <left>);
```

![cilp](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/2954776641-58e49bb2040e4_articlex.jpg?raw=true)

因此，我们使用clip来裁剪一下before，修改代码

```css
.coupon-left::before {
    top: -575px;
    clip: rect(575px,575px,685px,55px);
}
```

![clip-before](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20181220110917.png?raw=true)

再按照这种思路实现下半部分，调整一下after元素的top值和裁剪的起始值即可。

```css
 .coupon-left::after {
     content: '';
     position: absolute;
     right: -575px;
     width: 30px;
     height: 30px;
     border-radius: 50%;
     border: 560px solid #fff;
     top: -355px;
     clip: rect(465px,575px,575px,55px);
 }
```

最终效果如下：

![clip-left](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20181220111258.png?raw=true)

同样按照这样的思路可以实现右边部分。

完整代码如下：

```html
<div class="coupon">
    <div class="coupon-left"></div>
    <div class="coupon-right"></div>
  </div>
  <style>
    .coupon {
      width: 710px;
      height: 220px;
      border-radius: 8px;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .coupon-left {
      width: 520px;
      height: 220px;
      position: relative;
      overflow: hidden;
      /* background: #fff; */
    }
    .coupon-left::before, .coupon-left::after{
      content: '';
      position: absolute;
      right: -575px;
      width: 30px;
      height: 30px;
      border-radius: 50%;
      border: 560px solid #fff;
    }  
    .coupon-left::before {
      top: -575px;
      clip: rect(575px,575px,685px,55px);
    }
    .coupon-left::after {
      top: -355px;
      clip: rect(465px,575px,575px,55px);
    }
  

    .coupon-right {
      width: 190px;
      height: 220px;
      position: relative;
      overflow: hidden;
      /* background: #252525; */
    }
    .coupon-right::before, .coupon-right::after {
      content: '';
      position: absolute;
      right: -105px;
      width: 30px;
      height: 30px;
      border-radius: 50%;
      border: 280px solid #252525;
    }
    .coupon-right::before {
      top: -295px;
      clip: rect(295px,485px,405px,295px);
    }
    .coupon-right::after {
      top: -75px;
      clip: rect(185px,485px,295px,295px);
    }
  </style>
```

最终效果

![clip-coupon](https://github.com/undo03/Blog_Source/blob/theme_next/source/article_images/CSS/%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20181220112029.png?raw=true)

还有一个分割线，可以用绝对定位来实现。以上就是整个优惠券背景的实现。

#### 4. 相关知识点补充

- border-radius 是左上、右上、左下、右下四个方向的复合属性，有两种设值方式
  - <length>  定义圆形半径或椭圆的半长轴，半短轴。**负值无效**。
  - <percentage> 使用百分数定义圆形半径或椭圆的半长轴，半短轴。水平半轴相对于盒模型的宽度；垂直半轴相对于盒模型的高度。**负值无效**。
- clip The **clip** CSS property defines what portion of an element is visible. The `clip` property applies only to absolutely positioned elements, that is elements with `position:absolute` or `position:fixed`. The `<top>`, `<right>`, `<bottom>`, and `<left>` values may be either a <length> or `auto`. If any side's value is `auto`, the element is clipped to that side's *inside border edge*.

