---
layout: post
title: tags_by_postgres
---
对资源打标签在建站过程中是很常见的需求，有些时候我们需要给文章打标签，有些时候我们需要给用户打标签。实现一个标签系统其实并不难，其本质就是一个多对多的关系-我可以对同一篇博客打多个标签，同时也可以把一个标签打到不同的博客身上。这篇文章主要通过分析标签系统的原理，并用PostgreSQL来实现一个能够为多种资源打标签的标签系统。

## 1. 单一资源标签系统

先从单一资源开始，所谓单一资源便是，我们只给一种数据资源打标签。假设我们需要给博客文章打标签，那么我们需要构建以下几个表：

1. 文章表`posts`，用于存储文章的基本信息。
2. 标签表`tags`，用于存储标签的基本信息。
3. 标签-文章表`tags_posts`，存储双方的id并形成多对多的关系。

表设计图大概是

![Model Design for Simple Tag System](https://user-gold-cdn.xitu.io/2019/1/11/1683a54acce67589?w=844&h=475&f=png&s=28237)

先进入数据库引擎并创建对应的数据库

``` sql
postgres=# create database blog;
CREATE DATABASE

postgres=# \c blog;
blog=#
```

通过SQL语句创建上面所提到的数据表

``` sql
CREATE TABLE posts (
    id              SERIAL,
    body            text,
    title           varchar(80)
);

CREATE TABLE tags (
    id              SERIAL,
    name            varchar(80)
);

CREATE TABLE tags_posts (
    id              SERIAL,
    tag_id          integer,
    post_id         integer
);

```

每个表都只是包含了该资源最基础的字段, 到这一步为止其实已经构建好了一个最简单的标签系统了。接下来则是填充数据，我的策略是添加两篇文章，五个标签，给标题为`Ruby`的文章打上`language`标签，给标题为`Docker`的文章打上`container`的标签，两篇文章都要打上`tech`标签

``` sql
-- 填充文章数据
INSERT INTO posts (body, title) VALUES ('Hello Ruby', 'Ruby');
INSERT INTO posts (body, title) VALUES ('Hello Docker', 'Docker');

-- 填充标签数据
INSERT INTO tags (name) VALUES ('language');
INSERT INTO tags (name) VALUES ('container');
INSERT INTO tags (name) VALUES ('tech');

-- 为相关资源打上标签
INSERT INTO tags_posts (tag_id, post_id) VALUES ((SELECT id FROM tags WHERE name = 'container'), (SELECT id FROM posts WHERE title = 'Docker'));
INSERT INTO tags_posts (tag_id, post_id) VALUES ((SELECT id FROM tags WHERE name = 'tech'), (SELECT id FROM posts WHERE title = 'Docker'));
INSERT INTO tags_posts (tag_id, post_id) VALUES ((SELECT id FROM tags WHERE name = 'tech'), (SELECT id FROM posts WHERE title = 'Ruby'));
INSERT INTO tags_posts (tag_id, post_id) VALUES ((SELECT id FROM tags WHERE name = 'language'), (SELECT id FROM posts WHERE title = 'Ruby'));
```

然后分别查询两篇文章都被打上了什么标签。

``` sql
blog=# SELECT tags.name FROM tags, posts, tags_posts WHERE tags.id = tags_posts.tag_id AND posts.id = tags_posts.post_id AND posts.title = 'Ruby';
   name
----------
 language
 tech
(2 rows)

blog=# SELECT tags.name FROM tags, posts, tags_posts WHERE tags.id = tags_posts.tag_id AND posts.id = tags_posts.post_id AND posts.title = 'Docker';
   name
-----------
 container
 tech
(2 rows)
```

两篇文章都被打上期望的标签了，相关的语句有点长，一般生产线上不会这样直接操作数据库。各种编程语言的社区一般都对这种数据库操作进行了封装，这为编写业务代码带来了不少的便利性。

## 2. 为多种资源打标签

如果只需要对一个数据表打标签的话，依照上面的逻辑来设计表已经足够了。但是现实世界往往没那么简单，假设除了要给博客文章打标签之外，还需要给用户表打标签呢？我们需要把表设计得更灵活一些。如果继续用`tags`表来存标签数据，为了给用户打标签还得另外建一个名为`tags_users`的表来存储标签与用户数据之间的关系。

但更好的做法应该是采用名为`多态`的设计。创建关联表`taggings`，这个关联表除了会存储关联的两个id之外，还会存储被打上标签的资源类型，我们根据类型来区分被打标签的到底是哪种资源，这会在每条记录上多存了类型数据，不过好处就是可以少建表，所有的标签关系都通过一个表来存储。

Ruby比较流行的标签系统[ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on) 就沿用了这个设计，不过它的类型字段直接存的是对应资源的类名，或许是为了更方便编程吧，数据大概如下：

``` sql
naive_development=# select id, tag_id, taggable_type, taggable_id from taggings;
 id | tag_id |    taggable_type     | taggable_id
----+--------+----------------------+-------------
  1 |      1 | Refinery::Blog::Post |           1
  2 |      2 | Refinery::Blog::Post |           1
  3 |      3 | Refinery::Blog::Post |           1
```

先通过`taggable_type`获取类名，然后再利用`taggable_id`的数据就能准确获取相关的资源了。

### a. 修改原表

表设计图大概如下

![Model Design for multi](https://user-gold-cdn.xitu.io/2019/1/11/1683a568576a5569?w=1004&h=478&f=png&s=35092)

这里我不重新建表了，而直接修改原有的表，并进行数据迁移

1. 增加`type`字段用于存储资源类型。
2. 把原来的数据表改名为更通用的名字`taggings`。
3. 把原来的`post_id`字段改成更通用的名字`taggable_id`。
3. 给原有的资源填充数据，`type`字段统一填数据`post`。

``` sql
ALTER TABLE tags_posts ADD COLUMN type varchar(80);
ALTER TABLE tags_posts RENAME TO taggings;
ALTER TABLE taggings RENAME COLUMN post_id TO taggable_id;
UPDATE taggings SET type='post';
```

### b. 添加用户

在给用户打标签之前先创建用户表，并填充数据

``` sql
-- 创建简单的用户表
CREATE TABLE users (
    id              SERIAL,
    username        varchar(80),
    age             integer
);


-- 添加一个名为lan的用户，并添加两个相关的标签

INSERT INTO users (username, age) values ('lan', 26);

INSERT INTO tags (name) VALUES ('student');
INSERT INTO tags (name) VALUES ('programmer');
```

### c. 给用户打标签

接下来需要给用户`lan`打上标签，对原有的SQL语句做一些调整，并在打标签的时候把`type`字段填充为`user`。

``` sql
INSERT INTO taggings (tag_id, taggable_id, type) VALUES ((SELECT id FROM tags WHERE name = 'student'), (SELECT id FROM users WHERE username = 'lan'), 'user');

INSERT INTO taggings (tag_id, taggable_id, type) VALUES ((SELECT id FROM tags WHERE name = 'programmer'), (SELECT id FROM users WHERE username = 'lan'), 'user');
```

上述的SQL语句为用户打上了`student`以及`programmer`两个标签。

### d. 查看标签情况

为了完成这个任务我们依然要联合三张表进行查询，同时还要约束`type`的类型

- 用户名为`lan`的用户被打上的所有标签

``` sql
blog=# SELECT tags.name FROM tags, users, taggings WHERE tags.id = taggings.tag_id AND users.id = taggings.taggable_id AND taggings.type = 'user' AND users.username = 'lan';

    name
------------
 student
 programmer
(2 rows)
```

- 标题为`Ruby`的文章被打上的所有标签

``` sql
blog=# SELECT tags.name FROM tags, posts, taggings WHERE tags.id = taggings.tag_id AND posts.id = taggings.taggable_id AND taggings.type = 'post' AND posts.title = 'Ruby';

   name
----------
 language
 tech
```

OK，都跟预期一样，现在的标签系统就比较通用了。

## 总结

本文通过PostgreSQL的基础语句来构建了一个标签系统。实现了一个标签系统其实并不难，各个语言的社区应该都有相关的集成。本人也就是想抛开编程语言，从数据库层面来剖析一个标签系统的基本原理。

**PS: 另外推荐一个比较好用的Model Design工具[dbdiagram](https://dbdiagram.io/d/5c338362b2ae490014b825b7)，可以用文本的方式对数据表进行设计，边设计边预览。最后还能以PNG，PDF甚至SQL源文件的形式导出。本文的数据表配图均由用该软件制作。**
