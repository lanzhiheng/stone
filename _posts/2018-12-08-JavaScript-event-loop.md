---
layout: post
title: JavaScript-event-loop
---
原文链接: https://flaviocopes.com/node-event-loop/

## 指南

为了了解Node，**Event Loop**(后面我会翻译成“事件循环”)是其中最重要的方面。

为什么它如此重要？因为它表明了Node是怎样做到异步并且拥有非堵塞的I/O操作，当然也主要阐述了使得Node的“杀手级”应用得以成功的原因。

Node.js的代码在单线程上运行。也就是每一个时刻只会发生一件事情。

这是一种限制，实际上却非常有用，在很大程度上简化了你的应用程序而不需要担心并发的问题。

你只需要关心如何去编写你的代码，规避任何会堵塞你线程的东西。比如说同步的网络调用以及无限[循环](https://flaviocopes.com/javascript-loops/)。

通常，在大多数的浏览器中，每一个浏览器的Tab都有一个事件循环，这使得每一个处理过程相互隔离，且避免网页陷入无限循环或者繁重的处理过程中的时候会堵塞住整个浏览器。

特殊的浏览器环境管理着多个同时运行的事件循环，比如处理Api的调用。[Web Workers](https://flaviocopes.com/web-workers/)也是运行在它们自己的事件循环中。

你主要需要在意的是你的代码将会运行在单个事件循环上，编写代码的时候把它放在心上，避免堵塞它。

## 堵塞事件循环

任何JavaScript代码如果花费太长的时间才能够把控制权归还给事件循环的话，那将会堵塞页面中其他JavaScript代码的执行，甚至堵塞UI线程，使得用户不能够点击，滚动页面等等。

在JavaScript里面几乎所有原始的I/O操作都是是非堵塞的。如网络请求，文件系统操作等等。一般异常情况下才会被堵塞，这也是JavaScript里面有这么多的回调函数的原因，也包括最近出现的[promises](https://flaviocopes.com/javascript-promises/)以及[async/await](https://flaviocopes.com/javascript-async-await/)。

## 调用栈

调用栈是一个LIFO的队列（后进先出）。

事件循环会持续地检查调用栈，看看是否有需要被执行的函数。

在这个过程中，它会把从调用栈找到的所有函数添加进来，并依次调用它们。

你可能已经熟悉在调试工具或者浏览器console里面出现的错误栈跟踪信息了吧？浏览器从调用栈中查找函数名，然后告诉你哪个函数是当前调用的起源:

![error stack](https://flaviocopes.com/node-event-loop/exception-call-stack.png)

## 关于事件循环的简单描述

让我们选择一个例子:

``` js
const bar = () => console.log('bar')

const baz = () => console.log('baz')

const foo = () => {
  console.log('foo')
  bar()
  baz()
}

foo()
```

代码的打印结果是

```
foo
bar
baz
```

跟预期的一样，代码运行的时候首先调用`foo`函数，接下来在`foo`内部`bar`函数被调用，然后再调用函数`baz`。

该过程中调用栈看起来像这样。

![call stack](https://flaviocopes.com/node-event-loop/call-stack-first-example.png)

事件循环在每次迭代中都将会查看调用栈中是否有东西，有的话就并执行它：

![each interation](https://flaviocopes.com/node-event-loop/execution-order-first-example.png)

直到调用栈为空。

## 队列中函数的执行

上面的例子看起来很正常，没有任何特别的东西：JavaScript寻找一些需要执行的事物，并依次执行它们。

接下来让我们看看如何推迟一个函数的执行，直到调用栈为空才执行该函数。

案例`setTimeout(() => {}), 0)`将会唤起一个函数，但是这个函数将会等到代码中的其他函数都被执行完之后才会运行。

举个例子：

``` js
const bar = () => console.log('bar')

const baz = () => console.log('baz')

const foo = () => {
  console.log('foo')
  setTimeout(bar, 0)
  baz()
}

foo()
```

这段代码的打印结果可能有点出乎意料:

```
foo
baz
bar
```

当这段代码运行的时候，首先函数`foo`被调用，在`foo`内部首先会调用`setTimeout`，这里将会传入`bar`函数来作为它的第一个参数，另外为了让它能够尽快执行，传入参数`0`作为计时器的过期时间。接下来再调用`baz`函数。

此时调用栈看起来像这样：

![call stack with setTimeout](https://flaviocopes.com/node-event-loop/call-stack-second-example.png)

下面是我们的程序中所有函数的执行顺序：

![execution order with setTimeout](https://flaviocopes.com/node-event-loop/execution-order-second-example.png)

为什么会发生这种事情？

## 消息队列

当`setTimeout`被调用时，浏览器或者Node.js会开启一个[计时器](https://flaviocopes.com/timer-api/)。一旦计时器过期，回调函数就会被加入到消息队列中。而在这个例子中因为我们设置了`0`作为超时时间，所以函数将会马上被加入到**消息队列**。

消息队列是用户发起的事件，如点击事件或者键盘事件存活的地方。[fetch](https://flaviocopes.com/fetch-api/)的响应在能够被你代码使用之前也被放置于队列中。又或者是像`onLoad`那样的[DOM](事件)。

**事件循环给予调用栈较高的优先级，首先它会处理所有能够在调用栈中找到的函数，一旦调用栈为空，它就开始从消息队列中选取函数。**

我们不需要等待像`setTimeout`，`fetch`或者其他一些类似的函数完成它们的工作，因为它们是浏览器提供的功能，并且存活在他们自己的线程中。举个例子，如果你设置了`setTimeout`的超时时间为2秒，你并不需要等到两秒才能执行后续的代码-这个等待将会在其他地方进行。

## ES6工作队列

[ECMAScript 2015](https://flaviocopes.com/ecmascript/)提出了一个叫做工作队列的概念，Promises将会运用这个队列。这是一个尽可能快速地执行异步函数的方式，而不是把异步函数放置在调用栈的最后面。

Promises将在当前函数结束之前被加入到队列中，且将在当前函数之后被执行。

我找到一个很好的类比，就是娱乐公园的过山车。消息队列就像是把你放在队列之后，排在所有人的后面，你必须要等待你那个回合的到来。工作队列就像是一个快速通行证，在你完成上一个项目之后你就可以马上开始下一次的乘坐。

例子：

``` js
const bar = () => console.log('bar')

const baz = () => console.log('baz')

const foo = () => {
  console.log('foo')
  setTimeout(bar, 0)
  new Promise((resolve, reject) =>
    resolve('should be right after baz, before bar')
  ).then(resolve => console.log(resolve))
  baz()
}

foo()
```

打印结果是

```
foo
baz
should be right after baz, before bar
bar
```

这是Promises(以及构建于promises之上的Async/await)与旧的通过`setTimeout`或者其他平台API的异步方式之间比较大的不同。

## 结论

这篇文章为你介绍了关于Node.js事件循环的基本组成部分。

这是任何通过Node.js编写的程序的基本部分，我希望在这里阐述的一些概念在将来会对你有所帮助。

---

# [阅读我所有的Node.js教程](READ ALL MY NODE.JS TUTORIALS)
