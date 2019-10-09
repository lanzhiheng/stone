---
layout: post
title: DotDotDot
---
在做页面还原的时候难免会有文本截断的需求。所谓文本截断，就是在受限空间范围内我们只显示部分的文本内容，而把其他部分进行截断并隐藏起来。

形象点来说是这样的

原文本

```
  Hello Ruby, You So Cool.
```

截断之后大概就是这样子

```
  Hello Ruby, You...
```

当然，上面这种只是比较简单的单行文本截断，实际场景中的需求可能会更加复杂一些，且听我一一道来。

## 1. 服务端截断

作为一个前端程序员，最幸福的事情就是能够直接从后端拿到符合需求的数据，这样在使用之前就不需要再对服务端返回的数据进行处理。文本截断也是如此，如果我们能够让服务端按我们的预期做截断处理，那前端对接的时候也许会更加轻松一些。服务端截断处理起来还算比较方便，下面是Ruby On Rails的做法(严格来说应该是Active::Support的做法)

```
> "Hello Ruby, You So Cool.".truncate(10)
=> "Hello R..."

> "你好Ruby，你好世界，你好广州。".truncate(10)
=> "你好Ruby，..."
```

可见只需要告诉服务端我们需要多少个字，它就会返回我们期望的结果。而这种场景一般会跟页面跳转有关，下面是我们公司博客的搜索结果页面，在搜索列表页面中只显示截断的文本，如果要查看完整的博客内容则需要点击进入详情页面。

> Blog for Company

## 2. 单行客户端截断

然而通常情况下我们没有办法准确预测我们具体需要多少个字，截断的位置是由文本容器的来决定的。Google的首页就给我们展示这样一个例子，服务端返回完整的数据，我们需要运用CSS来对文本进行截断。

> Google 首页截图

这是单行文本截断，实现起来非常简单，我这里只列举出几个关键点

1. 容器要有固定的宽度。
2. `white-space`属性要设置成 `nowrap`这样无论多长的文本都会在一行显示。
3. `overflow`属性设置成`hidden`，把超出的文本都隐藏掉。
4. `text-overflow`属性设置成`ellipsis`，这样浏览器就会自动在文本的最后面设置`...`。

单行截断的效果堪称完美，一般会在标题太长容器无法容纳完整标题的情况下使用。

## 3. 多行文本截断

这种需求就稍微有点意思了。在Chrome浏览器里面可以通过比较简单的方式实现，下面是[网上](http://hackingui.com/front-end/a-pure-css-solution-for-multiline-text-truncation/)找到的代码

``` css
.block-with-text {
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;  
}

```
可以看到，关键的属性设置需要加`-webkit`前缀，它只能在`webkit`内核的浏览器上生效。查阅[MDN文档](https://developer.mozilla.org/zh-CN/)可知以上相关的属性并不是标准的一部分，其他浏览器将来会支持的可能性比较小，为了稳重起见，我们或许可以采取别的方式。

我们先不考虑文本变化的情况，假设我们有一个三行的长文本，在容器里面只需要显示前两行，也就是从第二行开始截断，效果如图所示

> 效果图

可以直接把容器的高度设置为两行，截断多余的部分就能实现两行的截断的效果。然而如何设置两行？这里可以采用`line-height`这个属性，根据`font-size`的倍数来设置我们的行高。然后再我们把容器的高度设置成两倍的行高，代码如下

``` css
.two-line-overflow {
  font-size: 18px;
  line-height: 1.5; /* 1.5 * 18 = 27px */
  height: 3em; /* 18 * 3 = 54px */
}
```

采用[em](https://developer.mozilla.org/zh-CN/docs/Web/CSS/length)和百分比而不是px来写死容器的高度以及行高，可以使我们的布局更加灵活。现在的容器高度就是行高的两倍了，接下来我们只需要用`overflow: hidden;`隐藏掉多余的东西，就可以做到只看到两行的文本。最后采用伪元素`:after`在文本的最后添加`...`便可实现我们想要的效果

``` css
.two-line-overflow {
  ...
  overflow: hidden;
  position: relative;
}

/* 把...定位到容器的右下角 ----- */
.two-line-overflow::after {
  content: '...';
  display: block;
  position: absolute;
  bottom: 0;
  right: 0;
}
```

然而现在的版本还有问题，当我们把`...`定位到容器的右下角，`...`会与我们右下角的文字会重叠在一起。而又因为我们设置了`overflow: hidden`，所以我们不能够把`...`定位到容器之外。为了修复这种偏差我们可以用`margin`跟`padding`来进行微调。

``` css
.two-line-overflow {
  ...
  padding-right: 1em; /* 给元素一个1em的右内边距, 这个时候文字会稍微被挤到左边 */
  margin-right: -0.5em; /* 添加负的外边距离，修复文字被挤到左边的差值 */
}

```

代码很简短，我稍微汇总一下

``` css
.two-line-overflow {
  font-size: 18px;
  line-height: 1.5; /* 1.5 * 18 = 27px */
  height: 3em; /* 18 * 3 = 54px */
  padding-right: 1em; /* 给元素一个1em的右内边距, 这个时候文字会稍微被挤到左边 */
  margin-right: -0.5em; /* 添加负的外边距离，修复文字被挤到左边的差值 */
  position: relative;
  overflow: hidden;
}

/* 把...定位到容器的右下角 ----- */
.two-line-overflow::after {
  content: '...';
  display: block;
  position: absolute;
  bottom: 0;
  right: 0;
}
```

## 4. 更灵活的多行截断

上面所讲的多行截断在文本字数比较多的情况下是能够达到我们的效果了，然而，它却有比较明显的缺陷。我们前面所论述的多行截断的情况只有在行数大于或者等于三行的时候才能够显示良好。在行数小于两行或者等于的时候就会很奇怪了

> 只有一行文本时候的两行截断

在一行文本的时候，在右下角也会出现`...`。这显然不符合我们的直觉。

为了让截断效果能够更加符合我们的应用场景，或许可以借用JavaScript的力量了

1. 使用JS判断所在文本的行高是否大于两行。
2. 如果大于两行则进行截断，并在第二行末尾显示`...`。如果小于或者等于两行则不需要进行任何截断操作。

假设我们的目标容器如下

``` html
<p class="js-overflow-adjust">
  Synthetic events (and subclasses) implement the DOM Level 3 Events API by
  normalizing browser quirks. Subclasses do not necessarily have to implement a
  DOM interface; custom application-specific events can also subclass this.
</p>
```

实现的JavaScript代码大概如下（为了让代码更加简短，我采用jQuery来实现这个过程）。

``` js
$('.js-overflow-adjust').each(function() {
  var $this = $(this)

  var FACTOR = 2

  /* 获取元素的行高，这里返回的是计算属性，单位是px */
  var elementLineHeight = parseInt($this.css('line-height'))

  /* 获取元素的高度，这里返回的也是计算属性，单位是px */
  var elementTotalHeight = parseInt($this.css('height'))

  if (elementTotalHeight / elementLineHeight > 2) {
    /* 当元素的行数大于两行的时候，为元素添加类 two-line-overflow */
    $this.addClass('two-line-overflow')
  }
})
```

这样就可以做到为包含文本为两行以上的容器添加我们所期待的两行截断的效果。

#### 结束了吗？

如果你只想做一个仅此而已的前端工程师，或者正在为内部系统做开发的话做到这一步可能已经足够了，然而如果我们是开发面向多用户(不仅仅是公司的几十号人)的网站，这样的效果显然是不可接受的。上面这种做法会导致让人难以接受的`闪烁感`。如果网络稍微有点慢的话，用户会明显地看到**页面先是显示所有的文本，然后长度大于两行的文本会突然被截断，变成两行文本。**显然这并不是一个好的用户体验。

修复这种闪烁感的方式可能有很多，这里我只简单谈谈我的做法。

为拥有类名`.js-overflow-adjust`的元素添加规则，默认透明显示。并且另外定义一个类用来控制我们该元素的透明度

``` css
.js-overflow-adjust {
  .....
  opacity: 0; /* 默认不显示 */
  transition: opacity 0.5s ease-in; /* 为透明度添加渐变效果 */
}

.js-element-visiable {
  opacity: 1;
}
```

用JavaScript控制当`闪烁`结束之后再把我们的容器显示出来，代码大概如下


``` js
$('.js-overflow-adjust').each(function() {
  ....

  /* 页面重绘完成之后给元素添加类`js-element-visiable`，然元素淡入我们的视线 */
  setTimeout(function() {
    $this.addClass('js-element-visiable')
  }, 500)
})
```

效果还算能够让人能够接受

> gif 效果图

## 尾声

本文主要列举了一些在页面中使用的文本截断的方式，分别讲述了在页面中如何做服务端文本截断，前端单行文本截断，以及前端多行文本截断。在前端多行截断的过程中，我们使用了JavaScript来让截断效果更加和谐。虽然不是什么大不了的技术，但也算是经验总结吧，很感谢你看到这里。

# Happy Coding and Writing!!
