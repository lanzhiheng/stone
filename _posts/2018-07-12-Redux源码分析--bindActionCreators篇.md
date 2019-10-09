---
layout: post
title: Redux源码分析--bindActionCreators篇
---
这是Redux源码分析系列的第四篇文章，当这篇文章结束之后Redux源码分析系列也该告一段落了。这篇文章主要想谈谈`bindActionCreators`这个函数的实现原理，为了更好的理解这个函数我会恰当地引入一些应用代码。

## 1. ActionCreator创建动作

在深入分析源码之前我们先来聊聊`ActionCreator`。从字面上理解，它是一个动作的创造者，或者说是动作的工厂。如果我们想根据不同的参数来生成不同步长的计数器动作，则可以把工厂函数声明为

``` js
const counterIncActionCreator = function(step) {
  return {
    type: 'INCREMENT',
    step: step || 1
  }
}
```

随着业务逻辑越来越复杂，我们可以通过定义更加复杂的工厂函数来生成更多样化的动作类型。

## 2. bindActionCreator高阶函数

从上述的例子出发，如果我们想生产出不同步长的计数器动作，并分发他们，则需要把代码写成下面这样子

``` js
// 为了简化代码我把dispatch函数定义为只有打印功能的函数
const dispatch = function(action) {
  console.log(action)
}

const action1 = counterIncActionCreator()
dispatch(action1) // { type: 'INCREMENT', step: 1 }

const action2 = counterIncActionCreator(2)
dispatch(action2) // { type: 'INCREMENT', step: 2 }

const action3 = counterIncActionCreator(3)
dispatch(action3) // { type: 'INCREMENT', step: 3 }
```

可见每次分发动作之前我们都得手动调用`counterIncActionCreator`来生产相应的动作，这种方式并不是那么的优雅。这个时候我们就可以采用[bindActionCreators](https://github.com/reduxjs/redux/blob/master/src/bindActionCreators.js)这个文件里面的`bindActionCreator`工具函数来优化代码了，该函数的源码如下

``` js
function bindActionCreator(actionCreator, dispatch) {
  return function() {
    return dispatch(actionCreator.apply(this, arguments))
  }
}
```

`bindActionCreator`将会返回一个新函数，这个函数会用自身所接收的参数来调用`actionCreator`并生成对应动作，并且这个生成的动作将会作为`dispatch`函数的参数。也就是说我们把

1. 生成动作
2. 调度动作

这两个步骤都封装到一个函数里面了，于是便得到了更为优雅的调度过程

``` js
...
const increment = bindActionCreator(counterIncActionCreator, dispatch)

increment() // { type: 'INCREMENT', step: 1 }

increment(2) // { type: 'INCREMENT', step: 2 }

increment(3) // { type: 'INCREMENT', step: 3 }
```

## 3. bindActionCreators

接下来看看`bindActionCreators`这个函数，它是`bindActionCreator`函数的加强版。删掉一些断言语句之后源码如下

``` js
export default function bindActionCreators(actionCreators, dispatch) {
  if (typeof actionCreators === 'function') { // #1
    return bindActionCreator(actionCreators, dispatch) // #2
  }

  ....

  const keys = Object.keys(actionCreators)
  const boundActionCreators = {}
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i]
    const actionCreator = actionCreators[key]
    if (typeof actionCreator === 'function') { // #3
      boundActionCreators[key] = bindActionCreator(actionCreator, dispatch)
    }
  }
  return boundActionCreators
}
```

代码`#1`的判断语句是为了做兼容处理，当接收的参数`actionCreators`为一个函数的时候，则认为它是单一的动作工厂，便在代码`#2`处直接调用`bindActionCreator`工具函数来封装调度过程。

另一情况是当`actionCreators`参数是一个对象的时候，则遍历这个对象。代码`#3`会判断每个键在原始对象中的值是否是个函数，如果是一个函数则认为它是一个动作工厂，并使用`bindActionCreator`函数来封装调度过程，最后把生成的新函数以同样的键`key`存储到`boundActionCreators`对象中。在函数的末尾会返回`boundActionCreators`对象。

举个简单应用例子，首先使用一个对象来存储两个事件工厂

``` js
const MyActionCreators = {
  increment: function(step) {
    return {
      type: 'INCREMENT',
      step: step || 1
    }
  },

  decrement: function(step) {
    return {
      type: 'DECREMENT',
      step: - (step || 1)
    }
  }
}
```

然后通过`bindActionCreators`来封装调度过程，并返回一个新的对象

``` js
const dispatch = function(action) {
  console.log(action)
}

const MyNewActionCreators = bindActionCreators(MyActionCreators, dispatch)
```

最后我们便可以用新的对象来主导调度过程了

``` js
MyNewActionCreators.increment() // { type: 'INCREMENT', step: 1 }
MyNewActionCreators.increment(2) // { type: 'INCREMENT', step: 2 }
MyNewActionCreators.increment(3) // { type: 'INCREMENT', step: 3 }
MyNewActionCreators.decrement() // { type: 'DECREMENT', step: -1 }
MyNewActionCreators.decrement(2) // { type: 'DECREMENT', step: -2 }
MyNewActionCreators.decrement(3) // { type: 'DECREMENT', step: -3 }
```

这种调度方式显然比原始的依次调用的方式更为优雅

``` js
// 原始的调度方式
dispatch(MyActionCreators.increment()) // { type: 'INCREMENT', step: 1 }
dispatch(MyActionCreators.increment(2)) // { type: 'INCREMENT', step: 2 }
dispatch(MyActionCreators.increment(3)) // { type: 'INCREMENT', step: 3 }
dispatch(MyActionCreators.decrement()) // { type: 'DECREMENT', step: -1 }
dispatch(MyActionCreators.decrement(2)) // { type: 'DECREMENT', step: -2 }
dispatch(MyActionCreators.decrement(3)) // { type: 'DECREMENT', step: -3 }
```

## 4. 尾声
这篇文章分析了高阶函数`bindActionCreators`的源码。它并不是什么复杂的函数，然而通过这类高阶函数我们就可以把原来笨重的函数调用过程封装起来，使最终的业务代码更加优雅。

# Happy Coding and Writing!!!
