---
layout: post
title: JavaScript继承原理
---
近期，公司的业务处于上升期，对人才的需求似乎比以往任何时候都多。作为公司的前端，有幸窥探到了公司的前端面试题目，其中有一题大概是这样的（别激动，题目已经改了）

> 请用你自己的方式来实现JavaScript的继承。

这不是当年让我束手无策的题目吗？然而我却痛苦地发现，在一年多以后的今天，即便我已经累计了不少的前端工作经验，但再次面对这道题目的时候我依然束手无策。

如果当时稍微懂一点ES6的话可能想都不想就能回答出来

``` js
class A extends B {

}
```

ES6总算给我们带来了`class`关键字，这使得JavaScript用起来更有面向对象编程语言的味道。然而JavaScript基于原型这一本质并没有变，今天就来谈谈语法糖衣背后的东西，在ES6还没有盛行之前我们如何做继承？了解了底层原理之后，上面的面试题就不再是问题了。

## 1. 基于原型

下面做一个简单的类比，可能描述得并不是十分准确。

如果我把类想象成一个模子，对象则犹如是往模子浇灌材料所铸造成的的器具。而这个模子，它规定了我们期望的器具的样式，规格，形状等属性，就如同编程语言里面类预先定制了它所能够产生的对象的属性，方法那样。

而原型，则可以理解成一个通过模子制作的器具，它拥有模子所预设的各种属性，它自身就是样式，规格，形状这些属性的集合，我们可以根据这个已有的器具去仿制更多同样的器具。

同样是用于生产，只不过从行为上来看他们**属性的源头**稍微有点不一样。**一种就如同设计师给了你一份文档，告诉你我要这样的产品，然后你把它量产。另一种就是给你一个成型的产品，告诉你我要一模一样的产品，然后你根据已有的产品去量产更多的相似产品。** 个人觉得JS基于原型的行为更像是后者。

## 2. JavaScript中的类定义

在ES5里面我们没有`class`关键字，这使得它面向对象的特性没有常规的面向对象语言那么直观，我们只能够通过方法来模拟类。我们来定义一个名为`Person`的类，并设置一个实例方法`printInformation`，代码如下

``` js
// 定义Person类
function Person(name, age) {
  this.name = name
  this.age = age
}

// 在原型上定义方法
Person.prototype.printInformation = function() {
  console.log("Name:" + this.name + " Age:" + this.age)
}

```

可见上面的代码有点反人类，起码不如一般的面向对象的编程语言直观。为了方便，我采用node环境来执行上面代码，并查看它的效果。

``` js
> me = new Person("Lan", 26)
Person { name: 'Lan', age: 26 }

> me.printInformation()
Name:Lan Age:26

> me.name
'Lan'

> me.age
26

> console.log(Person.prototype)
Person { printInformation: [Function] }
```

对象中的`name`与`age`两个属性就像是我们平时接触得比较多的实例变量，而放在原型中的`printInformation`方法就可以看成是实例方法。不过现在看来在JavaScript里面他们之间的界限似乎有点模糊，因为他们都可以通过对象来直接访问，他们之前的区别在后面讲继承的时候可能会越来越清晰。

## 3. ES5中的继承

如果用ES6的语法来实现继承的话，似乎没有什么难度，ES6提供了`class`语法，以及`extends`语法，使得我们很容易就能够实现类与类之间的继承，以下是React组件的官方推荐写法。

``` js
import React from 'react'

class Button extends React.Component {
  constructor(props) {
    super(props)

    ....
  }

  ...
}
```

语法十分简练，然而，在ES5的时候我们似乎并没有这么幸运，为了实现子类继承父类的行为，我们似乎需要做很多工作。下面就采用之前定义的`Person`来作为父类，另外再创建一个子类`Student`来继承它。

### 1) 继承父类实例变量

实例变量的初始化一般是放在构造函数中，而在ES5中我们可以直接把上面的`Person`这类函数看做是构造函数，另外`Student`构造函数也应该能够初始化`name`，`age`这两个实例变量。那么如何让`Student`所产生的对象也拥有两个字段呢？我们可以实例化的时候用当前上下文`this`去调用`Person`方法，那么当前的上下文就能够包含`name`与`age`这两个属性了。

``` js
function Student(name, age, school) {
  Person.call(this, name, age)
  this.school = school || ''
}
```

简单测试一下效果

``` js
> var student = new Student('Lan', 26)
undefined

> student
Student { name: 'Lan', age: 26, school: '' }
```

我们所创建的事例已经具备了`name`，`age`，`school`这三个字段了，然而实例方法呢？

``` js
> student.printInformation
undefined
```

似乎`Student`并没能继承父类`Person`的相关实例方法，接下来我们看看如何从原型链中获得父类的实例方法。

### 2) 从原型中获取方法

JavaScript是一门基于原型的面向对象编程语言。这里我们可以简单地把原型理解为一个对象，它包含了一些方法或者属性，只要为我们的**类**设定了这个原型，它所初始化的对象就能够拥有该原型中所包含的方法了。

``` js
> Person.prototype
Person { printInformation: [Function] }

> Student.prototype
Student {}
```

可见`Person`的原型中包含了一个方法，`Student`的原型中啥都没有。然而我们却不能够直接把`Person`的原型直接赋值给`Student`的原型，不然当`Student`往自身原型中添加方法的时候也会影响到`Person`的原型。怎么破？把原型拷贝一份呗。

一开始说过JS里面创建对象的过程有点像器具的仿造，所以我们可以用`Person`创建一个新的对象，然后把这个对象作为`Student`的原型。不过这样的话会有一个问题，如果用传统的`new`方法来创建对象的话，它还会包含一些杂质

``` js
> new Person()
Person { name: undefined, age: undefined }
```

这些属性应该在构造器中初始化的，我们不应该把他们放在原型中。这个时候我们可以借助ES5提供方法，创建一个稍微纯净点的对象。

``` js
> Object.create(Person.prototype)
Person {}
```

现在创建出来的对象没有包含构造函数中的实例变量了，我们可以用它来作为原型。稍微深入窥探一下`Object.create`的原理，其实我们可以用JS代码来简单模拟它(注意只是简单模拟)，更详细的内容可以参考[MDN文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create)，粗略的模拟代码如下

``` js
function createByPrototype(proto) {
  var F = function() {}
  F.prototype = proto
  return new F()
}
```

它接收一个原型作为参数，然后在内部创建一个**没有实例变量**的洁净函数，并把传入的参数设置为它的原型。最后使用这个函数来创建一个对象，所得到的对象就不会有实例变量了，但是它却能够访问原型中的方法，我们可以把它理解成一个新的原型

``` js
> var createObject = createByPrototype(Person.prototype)
undefined
> createObject.printInformation
[Function]
```

OK，理解了原理之后，我们依旧用`Object.create`来创建新的原型

``` js
Student.prototype = Object.create(Person.prototype)
```

简单演示一下

``` js
> var student = new Student('Lan', 26, 'GD')
undefined

> student
Person { name: 'Lan', age: 26, school: 'GD' }

> student.printInformation()
Name:Lan Age:26

// 小问题
> student.constructor
[Function: Person]
```

上面的结果表明我们的继承关系已经比较完善了，不过我遗留了一个小问题。我们从`student`实例去寻找它的构造器，却找到了`Person`这个构造函数，这显然是有问题的，原因我接下来讲。

### 3) 构造器

通过`student`对象获取构造器而时候无法得到`Student`这个构造函数，就相当于你问某个人的父亲叫啥名字，他告诉了你他爷爷的名字一样。咱大Ruby就没有这种问题

``` ruby
[1] pry(main)> class A < String
[1] pry(main)* end
=> nil
[2] pry(main)> a = A.new
=> ""
[3] pry(main)> a.class
=> A
```

在JavaScript中，对象在当前类的原型中找不到对应的属性，就会沿着原型链继续往上查找。回到上面的例子，因为`student`实例在`Student`类的原型中找不到`constructor`这个属性，所以它只能去更高层的`Person`的原型中去查找，所以才会得到这种结果

``` js
> Person.prototype.constructor
[Function: Person]

> Student.prototype.constructor
[Function: Person]
```

解决的办法很简单，就如同一个从小由爷爷扶养长大的孩子，很容易就把爷爷当成是父亲，你要做的只是告诉他他的父亲是谁，一句代码就可以了

``` js
Student.prototype.constructor = Student
....

> student.constructor
[Function: Student]
```

### 4. 代码汇总

对前面所讲的东西做个简单的代码汇总

``` js
// 定义一个简单的`类`，并包含实例变量
function Person(name, age) {
  this.name = name
  this.age = age
}

// 在原型链中定义`printInformation`方法
Person.prototype.printInformation = function() {
  console.log("Name:" + this.name + " Age:" + this.age)
}


// 定义一个Student子类，它会收集Person中的实例变量，并且自己会有一个新的实例变量 school
function Student(name, age, school) {
  Person.call(this, name, age)
  this.school = school || ''
}

// 继承Person原型中的方法，并在原型链中添加构造器属性
Student.prototype = Object.create(Person.prototype)
Student.prototype.constructor = Student
```

可见在ES5的时代连类的概念都不清晰，实现继承都一大堆的麻烦，现在都ES6/7的时代了，一般人应该不会这样写代码了。

另外，我上面所做的ES5实现的继承方式，跟如今Babel的做法并不完全一样，Babel细节方面处理得会稍微多一些，这篇文章我只是阐述了大致的继承原理。想要了解更多ES6转换到ES5的细节，可以在[Babel的网站](https://babeljs.io/repl/)上尝试。

## 尾声

今天这篇文章主要阐述了JavaScript基于原型的面向对象特性，以及在JavaScript里面要实现继承的注意事项。我们需要通过手动调用父类构造函数来继承父类的实例变量，还要通过设置原型来获取父类原型中的方法或者属性，最后要手动在原型链中设置`constructor`属性来指向自身构造器。虽然在ES6的时代我们不再需要手动地做这些事情了，Babel这些现代编译工具给我们提供了很多的语法糖衣。但是个人觉得**有些时候掌握这些老掉牙的知识或许能够让你更加深刻地理解这门语言的内涵，而不至于在工具盛行的今天，被各种工具，语法糖衣搞得晕头转向。面向工具编程是个高效的事情，然而当没有了工具就不会编程了，可就不是什么好事情了。**
