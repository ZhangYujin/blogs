---
title: junit4+log4j2 指定log4j2配置文件
date: 2017-03-28 11:50:19
tags: 
- java
categories:
- 编程
- java
- 配置
---
# junit4+log4j2 指定log4j2配置文件  

> 演示环境：eclipse  

在使用junit4进行单元测试时，尤其是java web项目，log4j2配置文件一般都不会出现在项目主目录，而是在配置文件子目录中。java web指定log4j配置是在web.xml文件中，而单元测试并不需要运行tomcat，于是log4j2找不到配置文件，经常在测试过程中出现以下提示：
````
ERROR StatusLogger No log4j2 configuration file found. Using default configuration: logging only errors to the console.
````
以上提示信息意思是：错误的日志状态，没有找到log4j2配置文件，使用默认的配置：只有error级别的信息会打印到控制台。
添加配置文件也很简单，只需要在jvm运行的时候添加参数：`-Dlog4j.configurationFile` 指定log4j2配置文件位置即可
1. 在单元测试中右键打开Run Configuration...或者debug Configuration,在VM arguments中添加配置文件位置即可![](http://i.imgur.com/L47IKwM.png)