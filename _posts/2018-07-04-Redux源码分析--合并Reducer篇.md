---
layout: post
title: Redux源码分析--合并Reducer篇
slug: Redux-yuan-ma-fen-xi--he-bing-Reducer-pian
---
之前两篇文章分别分析了Redux中间件，以及Redux的数据中心的源码，如今已经对Redux这个库有一定程度的了解了。可以说主菜都已经上齐了，剩下的只能算是饭后甜点了，而今天的甜点是`combineReducers`这个函数。今天我想谈论`combineReducers`这个函数的用法以及实现原理。

## 1. 模块化reducer

《三国演义》里面有句话是这样说的

> 话说天下大势，分久必合，合久必分

话说我们写代码的时候也有这种情况**当你一个文件包含的代码太多的时候我们会考虑按逻辑把它们拆分成几个模块，而当我们遇到一些细粒度模块的集合的时候，则会考虑把他们汇总为一个的模块。**

至于什么时候该拆，什么时候该合，可能不同的领域都有它自己的权衡方式，这里不详细讨论。在Redux应用里面reducer函数可以理解成一个处理状态的函数，它接受一个状态，以及一个动作，处理之后返回一个更新后的状态。一个简单的reducer函数大概如下

``` js
function reducerExample(state={}, action) {
  switch (action.type) {
    case 'INCREMENT':
      return Object.assign({}, state, {counter: state.counter + 1})
    case 'DECREMENT':
      return Object.assign({}, state, {counter: state.counter - 1})
    default:
      return state
  }
}
```

然而这个函数所包含的逻辑仅仅是对状态的`counter`字段进行加一以及减一操作。Redux是数据中心，它所管理的状态可能会包含很多个字段，当字段相当多的时候，我们需要在`reducerExample`函数中定义的操作也会渐渐多起来

``` js
function reducerExample(state={}, action) {
  switch (action.type) {
    case 'INCREMENT':
      return Object.assign({}, state, {counter: state.counter + 1})
    case 'DECREMENT':
      return Object.assign({}, state, {counter: state.counter - 1})
    case 'MULTI':
      return Object.assign({}, state, {otherCounter: state.otherCounter * 2})
    ....
    // 此处省略100行代码
    ....
    default:
      return state
  }
}
```

随着我们的状态越来越多，操作函数也将会越来越复杂，单一的reducer函数并非长久之计。这也是Redux为何提供`combineReducers`的原因，它使得我们可以以模块的方式来管理多个reducer函数。

简单讲解该函数的应用，假设Redux管理的应用状态如下

``` js
{
  counter: 0,
  article: {
    title: "",
    content: ""
  }
}
```

则我们可以分别定义两个reducer函数`counterReducer`与`articleReducer`

``` js
function counterReducer(counter=0, action) {
  ...
}
```

``` js
function articleReducer(article={}, action) {
  ...
}
```

在`counterReducer`里面只定义与`counter`字段有关的数据操作，而在`articleReducer`里面只定义与`article`字段有关的数据操作，最后通过`combineReducers`来合并两个reducer函数，并生成新的`reducer`函数，最后只需要把这个新的`reducer`函数与系统进行集成即可。

``` js
const reducer = combineReducers({
  counter: counterReducer,
  article: articleReducer
})
```

我们甚至可以把`counterReducer`与`articleReducer`两个函数放在不同的文件中，然后在同一个地方汇总(通过`combineReducers`合并)。当我们分发指定的动作之后只有定义了该动作的函数会改变对应字段的状态信息。

## 2. 源码分析

接下来分析一下`combineReducers`函数的工作原理。[combineReducers.js](https://github.com/reduxjs/redux/blob/master/src/combineReducers.js)这个文件代码加注释大概100多行，然而我们真正需要了解的核心就仅仅是该脚本中需要导出的`combineReducers`这个函数，其他代码大多是用于断言，暂且略过不谈。

### 1 收集所有的reducer方法

我们都知道函数接收对象的每个键所对应的值都应该是一个可以用于改变状态的reducer函数，为此我们会先遍历`combineReducers`函数所接收的对象，排除其中不是函数的字段。

``` js
export default function combineReducers(reducers) {
  const reducerKeys = Object.keys(reducers)
  const finalReducers = {}
  for (let i = 0; i < reducerKeys.length; i++) { // #1
    const key = reducerKeys[i]

    ....

    if (typeof reducers[key] === 'function') { // #2
      finalReducers[key] = reducers[key]
    }
  }

  ......
}
```

代码`#1`处开始遍历函数接收的对象的所有键，然后我们在代码`#2`处判断该键在原对象中指向的内容是否是一个函数。如果是函数的话，则把该函数以同样的键存储到`finalReducers`这个对象中，等循环结束之后`finalReducers`所包含的每一个键都指向对应的reducer函数了。

### 2. 返回一个新的reducer函数

`combineReducers`其实是一个reducer函数的工厂，在收集不同模块的reducer函数之后，它的责任就是返回一个新的reducer，而这个新的reducer函数能够调度先前收集的所有reducer。我把后续源码中的断言都去掉之后就剩下下列代码

``` js
export default function combineReducers(reducers) {
  ...

  const finalReducerKeys = Object.keys(finalReducers) // # 1

  return function combination(state = {}, action) {
    .....

    let hasChanged = false
    const nextState = {}
    for (let i = 0; i < finalReducerKeys.length; i++) {
      const key = finalReducerKeys[i]
      const reducer = finalReducers[key] // #2
      const previousStateForKey = state[key] // #3
      const nextStateForKey = reducer(previousStateForKey, action) // #4
      ....
      nextState[key] = nextStateForKey
      hasChanged = hasChanged || nextStateForKey !== previousStateForKey
    }
    return hasChanged ? nextState : state
  }
}
```

首先会在代码`#1`处获取先前过滤好的`finalReducers`对象的所有键。然后当前函数会返回一个新的reducer函数，这个函数能够访问`finalReducers`形成一个闭包。

当调用这个新的reducer函数的时会遍历`finalReducerKeys`这个数组中的每一个键，在代码`#2`处获取当前键所对应的reducer函数`reducer`，并在代码`#3`处获取当前键所对应的状态`previousStateForKey`。

接下来在代码`#4`处以当前状态`previousStateForKey`以及`action`作为参数来调用`reducer`，返回该键所对应的新状态`nextStateForKey`。在每次迭代中都会把当前键`key`作为字段，把新的状态存储到`nextState`这个对象中去，循环结束之后，我们就能够保证`action`被顺利调度了。

另外，还记得我们编写reducer函数的时候总会使用这种语法吗？

``` js
Object.assign({}, state, {counter: state.counter + 1})
```

这表明了我们不会在原来的`state`基础上进行修改操作，而是生成了一个新的`state`，原理大概如下

``` js
> a = {}
{}
> b = Object.assign(a, {counter: 1})
{ counter: 1 }
> c = Object.assign({}, a, {counter: 1})
{ counter: 1 }
> a === b
true
> a === c
false
```

而在Redux中，正常情况下如果reducer方法被调用后并没有产生新的对象，而只是在原有的对象中进行操作的话，则在绑定组件的时候，状态的修改将不会引起组件的更新。

在`combineReducers`这个函数里面也会有相应的处理，这里需要着重关注`hasChanged`这个变量

``` js
...
  return hasChanged ? nextState : state
...
```

当且仅当，这个变量为真值的时候我们才会返回新的状态，不然的话依旧返回原有的状态。这个`hasChanged`是由以下代码控制的

``` js
...
for (let i = 0; i < finalReducerKeys.length; i++) {
  ....
  hasChanged = hasChanged || nextStateForKey !== previousStateForKey
}
```

也就是说在所有的迭代中至少有一个迭代符合`nextStateForKey !== previousStateForKey`这个条件的时候(所对应的reducer返回了新的对象)`hasChanged`才会为真，新的reducer函数才会返回新的状态对象`nextState`。否则将返回原有的状态对象`state`，在绑定React组件的时候则有可能会出现状态数据更新了，组件却没有响应的情况。

## 3. 尾声

这篇文章简单地介绍了一下`combineReducers`这个函数的用法并简单地分析了`combineReducers`的源码，我们可以通过这个函数以模块的方式管理代码。然而，模块化是把双刃剑，过度模块化也是不可取的，这得看每个开发者的经验和权衡能力了。

# Happy Coding and Writing !!!
