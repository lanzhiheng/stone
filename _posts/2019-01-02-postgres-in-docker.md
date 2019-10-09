---
layout: post
title: postgres-in-docker
---
这篇文章会以容器的方式运行Postgres服务作为例子简单介绍一些容器管理相关的命令，我们会看到容器的表现像是一个操作系统的进程，而镜像则像是一个“源码库”，一切容器的启动都依赖于它。此外还会介绍容器内的服务与外界打交道的方式，我们或许可以利用容器的这种特性在日常开发中采用容器服务。

## 容器服务

抛开底层技术还有一些较为高级的集群服务不谈，或许可以把Docker服务简单理解为**一个托管着镜像并能够利用镜像来调度容器的地方。**这些镜像根据操作系统的不同或者说Docker版本的不同被托管在不同的目录下。

每次Docker要启动容器的时候都会在这个目录下以它的内部程序寻找相关的镜像，如果有相关的镜像存在则直接使用，否则会从相关的托管网站下载镜像，比如[DockerHub](https://hub.docker.com/)。

启动Postgres容器的方式相当简单，直接运行脚本即可

```
docker run postgres
```

容器启动之后会显示一堆日志信息

```
2019-01-02 10:40:46.987 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2019-01-02 10:40:46.989 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2019-01-02 10:40:46.997 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2019-01-02 10:40:47.020 UTC [52] LOG:  database system was shut down at 2019-01-02 10:40:46 UTC
2019-01-02 10:40:47.029 UTC [1] LOG:  database system is ready to accept connections
```

通常以非容器的方式启动Postgres服务也会有类似的日志信息，只不过由于配置的关系我们无法从命令行直接读取这些日志信息，它们都记录在相关的日志文件中。这种容器的默认启动方式除了会在命令行直接显示相关之外，还会占用一个窗口，这对于开发者而言并不是那么友好。停止原有的服务并添加`-d`参数重新启动，即可让相关的容器服务以守护进程的形式在后台运行。

```
> docker run -d postgres
3ac6e6a43546aed69349d1d523f3c4279a6c595dc848be3d512b73dfc2993879


> docker container ps # 镜像已经正常启动
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
3ac6e6a43546        postgres            "docker-entrypoint.s…"   16 seconds ago      Up 15 seconds       5432/tcp            ecstatic_pascal
```

这里似乎有个有用的信息，以容器方式启动的Postgres服务是以`5432`这个端口启动的，它是Postgres服务的默认端口。我们在系统层面检查一下这个端口是否被占用

```
> sudo lsof -i :5432
>
```

可见端口没有被占用，可以理解为**容器内服务的相关端口完全与外界隔离了**，这倒是给我们省了不少事情。要使用这个服务可以进入到容器内部

```
docker exec -it 3ac6e6a43546 bash # 通过指定容器id向容器发送相关的命令，并以交互的方式运行
root@3ac6e6a43546:/#
```

登入后通过容器内的Postgres客户端`psql`即可连接相应的Postgres服务

```
root@3ac6e6a43546:/# psql -U postgres
psql (11.1 (Debian 11.1-1.pgdg90+1))
Type "help" for help.

postgres=#
```

接着就可以用Postgres的相关命令操作数据库了，这里不详细说。

## 容器与外界交互

正如前面所说到的，基于容器的服务，它的端口都与外界隔离着，因此不需要担心端口冲突的问题。但是如果每次使用服务都要借助Docker命令进入容器内部是很无聊的一件事情，而这种限制下容器带给人们的好处也很有限。我们需要寻求把容器服务暴露给外界的方法。

简单来说所需要做的事情只有**把容器的内部服务端口跟外界的端口做个映射**。之前的容器进程我们先放着不管。重新启动一个容器，并通过`-p`参数做端口映射，这里我把容器内部的`5432`端口映射到外界的`6700`端口

```
docker run  -d -p 6700:5432 postgres
```

再次查看容器列表

```
> docker container ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
8f8c80f8177b        postgres            "docker-entrypoint.s…"   44 seconds ago      Up 44 seconds       0.0.0.0:6700->5432/tcp   nifty_mayer
3ac6e6a43546        postgres            "docker-entrypoint.s…"   17 hours ago        Up 6 minutes        5432/tcp                 ecstatic_pascal
```

新启动的容器ID为`8f8c80f8177b`，注意力集中在`PORTS`那一列，该容器有一条端口映射的信息`0.0.0.0:6700->5432/tcp`，检查一下相关的端口，可以看到有相应的进程在运行

```
> lsof -i :6700
COMMAND    PID USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
com.docke 2511  lan   21u  IPv4 0xa28bb36c099582e3      0t0  TCP *:6700 (LISTEN)
com.docke 2511  lan   23u  IPv6 0xa28bb36becd214fb      0t0  TCP localhost:6700 (LISTEN)
```

这个时候我们可以通过`6700`端口来访问容器内的Postgres服务了。不过这里需要走TCP协议，稍稍做个验证

```
> psql -U postgres -h 127.0.0.1 -p 5432 # Case1
psql: could not connect to server: Connection refused
	Is the server running on host "127.0.0.1" and accepting
	TCP/IP connections on port 5432?

> psql -U postgres  -p 6700 # Case2
psql: could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/tmp/.s.PGSQL.6700"?

> psql -U postgres -h 127.0.0.1 -p 6700 # Case3
psql (9.6.10, server 11.1 (Debian 11.1-1.pgdg90+1))
WARNING: psql major version 9.6, server major version 11.
         Some psql features might not work.
Type "help" for help.

postgres=#
```

几点需要注意的

- **Case1:** 因为容器`3ac6e6a43546`中服务的端口没有暴露出来，所以我们无法在本机的客户端对其进行访问。
- **Case2:** 容器`8f8c80f8177b`内的Postgres服务所有文件都托管在容器中，它并没有在容器外创建SOCKET协议的相关文件，因此我们无法以默认的SOCKET协议对其进行访问。
- **Case3:** 由于容器`8f8c80f8177b`把Postgres服务的端口暴露给了外界，我们可以通过明确指定相关的IP和端口让客户端以TCP协议访问相关的Postgres服务。


## 开发环境下的用途

容器服务虽说管理起来没有“正常服务”那么直观，但这种服务的好处就是隔离性比较好。用运维小伙伴的话来说就是

> 我不用再担心当一个Web应用被攻击它的数据库服务挂了的时候其他的Web应用也跟着遭殃。

开发环境下是自然是不用考虑宕机的事情了，不过假设有些时候你不想通过编译源码，包管理等方式来安装相关的服务。或者你同时管理着几个项目而不同项目会有连接不同版本数据库的需求，这种情况下就可以考虑在开发环境下采用容器服务了。

通过下载不同版本的数据库服务的相关镜像比如`postgres:9.x`, `postgres:11.x`。然后基于这些镜像启动相关的容器服务，并暴露特定端口。然后简单修改应用程序的配置文件让应用可以分别连接到对应的数据库。另一方面，基于容器的服务删除起来比较容易，不像本地编译安装的软件，基本都要手动去删除好几个目录中的相关内容，很多时候你都会怀疑自己到底删除干净没有。

## 总结

本文通过容器来启动了Postgres服务，并对它进行了一系列的操作，稍微窥探了容器服务到底是个什么样的东西，当然比起窥探源码这种程度的探索还是显得比较表面，不过理解这些基本点还是有助于日后的发展。

PS：本文对于容器的管理只是限于“进程”层面的管理，如果需要一个可靠的容器服务单单是这样是不足够的，我们还需要涉及到“数据”层面的管理。如果我们把所有东西都放在容器中一旦容器不小心被销毁，一切努力都将会白费。要知道销毁一个容器就跟杀死一个进程那么容易。这时我们可能会需要在容器外维护一份配置文件，或者为容器内存储数据的目录做一个数据卷的映射，这样即便容器被销毁了，我们依然可以保留工作成果。

