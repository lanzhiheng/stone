---
layout: post
title: rails项目中集成sourcemap
slug: rails-xiang-mu-zhong-ji-cheng-sourcemap
---
写这篇文章主要为了总结近期Rollbar在Rails项目中的使用情况，其中包括Rollbar与Heroku的合作关系，Rollbar跟Source Map如何搭配使用。当我们的线上压缩过的代码发生异常的时候，我们也能准确定位到是哪一行发生的异常。有助于我们构建更加健壮的应用程序并且提高我们的维护效率。

<!-- More -->

![Rollbar](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvMnhsaGZqaWN1bF8xOTI4ODNfN2U2Yjg3ZDBlYjcxNzBhZS5wbmciXV0/192883-7e6b87d0eb7170ae.png?sha=53c7d1f065e218f6)

## 1. Rollbar-异常跟踪服务

如果曾经用过Sentry，听云这些服务应该对生产环境的监控有所了解，Rollbar其实也是担任了这类角色。在我厂的一些Rails项目中，主要使用Rollbar来做一些生产环境中异常的监控。**毕竟生产环境与我们开发环境情况不同，许多时候我们没办法预测客户的行为，通过集成Rollbar这类监控服务有助于我们及时发现系统中存在的问题，并能够迅速定位到引发问题的代码。**

#### 1) Rollbar On Heroku

对于Heroku大家都应该熟悉，我们可以在上面创建我们的App容器，绑定Github账号之后可以轻松地部署我们Github上的Web项目，并且它还提供许多实用的命令行工具方便我们对项目进行管理（当然不限于Rails项目）。

个人觉得这个平台还是挺好的，我们不需要写部署脚本就可以一键部署我们的代码。如果你不想自己管数据库，不想管域名，不想写部署脚本它或许是个不错的选择，当然如果你想要更好的体验它也是有收费版的。

![Money](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvcGphZGt0enhvX1NjcmVlbl9TaG90XzIwMThfMDNfMjJfYXRfMTEuNTMuMDFfQU0ucG5nIl1d/Screen%20Shot%202018-03-22%20at%2011.53.01%20AM.png?sha=48fabac8f3c36a8e)

但国内或许因为众所周知的原因，大家似乎都不太倾向于这个服务，而外国的同行倒是比较倾向于它，我觉得可能除了部署应用方便之外，还因为它还能够方便地去集成一些比较实用的第三方服务，如New Relic(代码性能分析)，Pappertrail（系统日志查看）等等。

如图，只需要搜索并安装便可

![Install Rollbar](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvOWxyaDE5ejQ4eV9TY3JlZW5fU2hvdF8yMDE4XzAzXzIxX2F0XzguNDMuNTRfQU0ucG5nIl1d/Screen%20Shot%202018-03-21%20at%208.43.54%20AM.png?sha=e35a3e732f698a1b)

日后当我们需要查阅App的异常记录的时候只需要从Heroku的资源列表中选中Rollbar则能够直接跳转到Rollbar的管理页面查看相关信息。

#### 2) Rollbar配置

Rollbar作为一个第三方的监控服务，对大多数语言都提供了支持，我们只需要简单安装对应语言的SDK并且附上简单的配置就可以轻松对接这一服务。具体我们可以通过查看[Rollbar服务SDK](https://rollbar.com/docs/)来查阅Rollbar对语言的支持情况以及相关的配置。下面是Ruby语言对Rollbar的使用

![Use By Ruby](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvcWY0OHphNHJlX1NjcmVlbl9TaG90XzIwMThfMDNfMjFfYXRfOC4xNi41Ml9BTS5wbmciXV0/Screen%20Shot%202018-03-21%20at%208.16.52%20AM.png?sha=e81ee2a1e09435c6)

可见十分简单，这样我们在Rollbar的页面上就能看到对应的错误。接下来我结合实际Web项目来说说具体使用方式。

一个Web服务最基本的需要监控的异常源头应该就是下面这两个

1. 前端JS异常
2. 后端业务逻辑异常

而Rails项目在Rollbar里面监控起来大概是这样子，能够区分前端跟后端的错误信息，并且提供搜索功能。

![Rollbar Dashboard](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvODZxaDd3a3NhbF8xOTI4ODNfZDEwNjIxOGZiODZhMWZmNC5wbmciXV0/192883-d106218fb86a1ff4.png?sha=36ea935c922a5917)

Rails项目中集成Rollbar总的来说只需要**一个名为[rollbar-gem](https://github.com/rollbar/rollbar-gem)的Gem，一条命令，两个assess token.... 没了**。具体操作可以参考上面的文档，以下是配置文件的概况

``` ruby
Rollbar.configure do |config|
  ......
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN'] # (1)

  ......

  config.js_enabled = true
  config.js_options = {
    accessToken: ENV['ROLLBAR_CLIENT_ACCESS_TOKEN'], # (2)
    captureUncaught: true,
    ....
  }

  ...
end
```

配置很简单，大部分内容是通过命令来生成的。需要注意的是这里有两个assess token，一个是用来对接Ruby端的监控，另一个是用来对接JavaScript方面的监控。我们一般不会把他们硬编码到代码里面，而是以环境变量的方式去管理。

常规的方式是在项目根目录下使用`.env`文件配上相关的Gem----[dotenv](https://github.com/bkeepers/dotenv)。不过如果你的项目是跑在Heroku上面的话就不需要这样了

![Environment Variables Configuration](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvNTNxa2JvYm1hMF8yMDE4MzIyMTY1NzAzZGFtYS5wbmciXV0/2018322165703dama.png?sha=28311c3323281373)


Heroku提供了图形界面以及相关的命令行来管理工具让我们可以在Heroku的服务端配置相应的环境变量，因此在用Heroku部署的时候我们可以不装载[dotenv](https://github.com/bkeepers/dotenv)这个Gem了。

## 2. Rollbar With Source Map

有一定前端开发经验的朋友应该会听说过Source Map，**简单来说它的功能就相当于一副地图，当我们线上压缩过的代码报错的时候，它能够给予我们足够的信息，让我们知道当前报错的代码对应压缩前的代码的哪一行那一列。**

#### 1) 让你的Rails项目能够生成Source Map

在Rails里面JavaScript资源是通过一个叫Sprockets的库对文件进行聚合，然后再进行压缩。目前稳定版本的Sprockets默认还不支持Source Map，[官方文档](https://github.com/rails/sprockets)说需要等到4.x版本才能够支持Source Map，但是如果在已有的项目中要升级Sprockets的话会有以下问题

- 4.x版本并不是稳定版本，还是Beta状态，贸然升级有风险。
- 4.x版本跟原来的3.x版本相比是属于大版本更新，许多写法都不兼容，对一个线上运行的项目进行如此大的改动并不是一个明智的做法。

这个时候我们可以去寻找一下是否有相关的增强库，我推荐[sprockets_uglifier_with_source_maps](https://github.com/AlexanderPavlenko/sprockets_uglifier_with_source_maps)这个库，它可以兼容Rails5.x大家可以放心使用，另外它的源码比较简单，有兴趣的同学可以去看一下。

在Rails项目中只需要简单在配置文件中把原来`config.assets.js_compressor`配置中的值改成`:uglifier_with_source_maps`便可

```
config.assets.js_compressor = :uglifier_with_source_maps
```

在下次Asset Pipeline的时候就会默认在`public/assets/maps`文件中生成Source Map文件，在`public/assets/sources`文件中生成经过聚合的还没压缩过的源文件。

PS: *在Rails中Sprockets会先把所有JS资源汇总成一份，然后再传入Uglifier压缩器中压缩，这就导致了生成的Source Map文件是以汇总过的文件作为参考，而不是以我们代码库里面的文件作为参考。*具体可以看下面这个Source Map文件的内容，它的`sources`字段里面永远都只有一个文件。

```
> more public/assets/maps/application-c96c5c1dd9b08fe61e8bdf2b63abc2fe55a8c0f568d966aaa2233a978498bf56.js.map
{"version":3,"sources":["assets/sources/application-c04f01e07f02fe23078171694d1ccb7182bbd11759e093567f485021cf5617c9.js"]....
```

换句话说**通过这个库生成的Source Map文件并不能准确定位到我们源码库具体哪个文件的哪一行报错，它只能够定位到我们源码经过聚合之后的那个文件具体哪一行报错。这个库在生成Source Map的时候也会顺便生成聚合过的文件，估计是方便大家对代码的调试。**

#### 2) 让Rollbar可以使用Source Map文件

当我们生成了Source Map之后，我们便可以在浏览器的Inspect调试窗口看到我们报错的代码具体对应压缩前的代码的哪一行那一列了。大概像这样

![Error Information In Inspect](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvOGo4YWJmdzd5aV8xOTI4ODNfYWFiNDRlN2Y4Njc5M2U5Ny5wbmciXV0/192883-aab44e7f86793e97.png?sha=98a4c17aa9e0ffe4)

但这仅仅是我们本地能够看到而已，Rollbar看不到，在这种情况下Rollbar只能接收到类似这样的信息。

![Error Information In Rollbar](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvMWw1eXdyY3R2YV8xOTI4ODNfMDIyNjVhM2RjMTMzODkzMy5wbmciXV0/192883-02265a3dc1338933.png?sha=1ad35d68dc3b2b41)


我们也不可能要求用户在遇到问题的时候都打开开发者调试工具，然后把错误贴给我们。为此，我们需要让Rollbar能够使用我们生成的Source Map文件，对应的参考文档[在此](https://rollbar.com/docs/source-maps/)。我简单的总结了一下有以下两种方式。

##### a. 上传Source Map到Rollbar服务器

这种方式看起来有点复杂，也是Rollbar官网比较推崇的一种方式，它通过这样的POST请求把我们Source Map文件推送到服务器

```
curl https://api.rollbar.com/api/1/sourcemap \
  -F access_token=aaaabbbbccccddddeeeeffff00001111 \
  -F version=version_string_here \
  -F minified_url=http://example.com/static/js/example.min.js \
  -F source_map=@static/js/example.min.map \
  -F static/js/site.js=@static/js/site.js \
  -F static/js/util.js=@static/js/util.js
```

其实我们只需要关注`access_token`, `version`, `minified_url`, `source_map`这几个参数便可，剩下参数是可选。接下来我们还需要做的就是配置`rollbar.js`，还记得我们之前生成的配置文件吗？我们只需要在里面加上js的相关配置即可。

``` ruby
Rollbar.configure do |config|
  ......
  config.js_enabled = true
  config.js_options = {
    accessToken: ENV['ROLLBAR_CLIENT_ACCESS_TOKEN'],
    captureUncaught: true,
    payload: {
      environment: Rails.env,
      client: {
        javascript: {
          source_map_enabled: true,
          code_version: ROLLBAR_JS_CODE_VERSION,
          guess_uncaught_frames: true
        }
      }
    }
  }
  ...
end
```

需要注意这里的`code_version`字段与调用上传api时候的`version`字段要一一对应，这样当代码报错的时候`rollbar.js`才能找到对应版本。已经上传的Source Map文件列表可以在Rollbar的Source Map设置页面中查看，大概如下

![Source Map Manager](http://www.beansmile.com/system/images/W1siZiIsIjIwMTgvMDMvMjIvNG1uaTdsc2Q1OV8xOTI4ODNfYmU1NTY3YTNjMjVkNTBjZC5wbmciXV0/192883-be5567a3c25d50cd.png?sha=876f8e7f343c96a8)

你也可以手动上传，但是我还是建议把一切自动化。在Rails项目里我通过编写一个Rake任务，在`assets:precompile`之后进行自动上传，相关Ruby代码在[这个链接](https://github.com/lanzhiheng/sourcemap-demon/blob/feature/upload-rollbar-sourcemap/lib/tasks/precompile_overrides.rake)。另外我在配置中预设一个`ROLLBAR_JS_CODE_VERSION`常量，来保证Rake任务与服务启动时的js共用同一个`ROLLBAR_JS_CODE_VERSION`。

虽然每次上传都用同一个`ROLLBAR_JS_CODE_VERSION`并无大碍，Rollbar依然能够根据文件名的不同准确找到对应Source Map文件，但如果我们能够每次部署都使用不同的`ROLLBAR_JS_CODE_VERSION`，通过管理页面来查看也更加清晰，我们管理起来也更加顺手了。

##### b. 生成Source Map的时候添加对应的域名

第一种方式虽然是官网推荐，但是相对而言还是比较费力的，一方面要生成Source Map文件，另一方面还要把他们上传到Rollbar服务端，长期下去你Rollbar的Source Map管理页面就会充满了各种版本Source Map，如果你每次部署都用同一个`ROLLBAR_JS_CODE_VERSION`的话你管理起来就更加混乱了。

其实Rollbar提供了一种更为简单的方式，我们只需要在压缩好的资源最底部的Source Map链接加上生产环境的域名，让它构成一个完整的http链接便可，当错误发生的时候`rollbar.js`就会通过相应的链接来寻找对应的Source Map文件。

用之前提到的[sprockets_uglifier_with_source_maps](https://github.com/AlexanderPavlenko/sprockets_uglifier_with_source_maps)这个Gem来实现这个过程可以说是相当容易。我们只需要在配置的时候加上这一条

```
Rails.application.config.assets.sourcemaps_url_root = ENV['CDN_ADDRESS']
```

再次运行`assets:precompile`之后，在被压缩过的js文件底部的Source Map路径上就会添加了对应的`CDN_ADDRESS`环境变量的域名，结果大概如下

```
> tail -n 1 public/assets/application-10ea497a8e7f07dd06d9e0e31eb29fd90e12b195dd16a9c976b3607b41435a24.js
//# sourceMappingURL=https://sourcemap-demon.herokuapp.com/assets/maps/application-c96c5c1dd9b08fe61e8bdf2b63abc2fe55a8c0f568d966aaa2233a978498bf56.js.map
```

注意以前的版本是没有域名的

```
> tail -n 1 public/assets/application-d82b6dd95ceac4f6011b0cca1bf400ebf89f3cdf97a4a29f2738eb1f0dedbef0.js
//# sourceMappingURL=/assets/maps/application-d547f95a9071ea5442a587c4a6f7f15703baf08cba2c998ffc7f8dfb248be9e7.js.map
```

几乎不用做更多的东西了。把配置写好之后直接把我们的代码部署到生产环境就可以了。当错误发生的时候，Rollbar可以捕获到我们生产环境下的js错误，并且根据这个链接获取Source Map来定位我们的错误。

##### c. 两种方式对比

这两种方法我都在这个[Repo](https://github.com/lanzhiheng/sourcemap-demon)中简单实现了，修改url的方式我写在了`master`分支，上传文件的方式我写在了`feature/upload-rollbar-sourcemap`这条分支，如果懒得自己写上传流程的话可以上去拷贝一下代码。下面我简单地对比一下两种方法

###### 上传的方式

优点: 我们只需要在生成Source Map的之后把对应的文件通过Api或者手动的方式上传到Rollbar的服务端，Rollbar便可以收集并定位我们的错误，其中需要注意的是Api中的`version`字段应该与`rollbar.js`配置中的`code_version`字段要一一对应。上传完之后我们便可把本地生成的Source Map文件，以及聚合后的源码文件移除，不需要把相关的文件暴露到线上，当然也可以备份起来方便以后调试。

缺点: 实现起来稍微有点费劲，特别是每次部署都要用不同的`ROLLBAR_JS_CODE_VERSION`的时候。如果是常规项目还好，我们可以在部署的时候获取代码仓库的`Git SHA`来自动设置`ROLLBAR_JS_CODE_VERSION`环境变量，并且存到`.env`文件中，让Rake任务与运行环境可以共享同一个`ROLLBAR_JS_CODE_VERSION`，还能保证每次部署都使用不同的`ROLLBAR_JS_CODE_VERSION`。但是在Heroku中的项目就不那么容易了，我们的环境变量都都需要在网站或者命令行中去设置，而在部署脚本不归自己管的情况下要使这个行为自动化并不那么容易。

###### 添加对应域名的方式

优点: 十分简单，特别在Rails项目里面稍微添加一些配置就能够实现，并且运行良好。

缺点: 没有压缩过的源代码以及Source Map文件会在生产环境中暴露(默认放在`sources`, `maps`这两个目录下)。另外在第一个错误到来时如果对应的Source Map文件还没下载成功会可能会导致我们第一个错误没办法定位。

*个人建议: 在我们不在意暴露源码的情况下我更倾向于第二种方式，它更简单，不需要太多的折腾就可以基本达到我们的要求。*

## 3. 尾声

这篇文章主要是想介绍一下Rollbar，并且讲一下它如何与Heroku结合使用。也花了一定的篇幅介绍了如何在Rails项目里面如何生成Source Map文件以及搭配Rollbar使用的方式。尽管我已经尽量克制自己少贴源码，免得徒增篇幅，但一篇文章写下来篇幅还是超出预想，还望见谅。

# Happy Coding and Writing!!
