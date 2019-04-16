---
title: netty基础教程--简介
date: 2017-10-30 14:35:40
tags: netty
categories:
- 编程
- netty
---
## OIO和NIO
在传统的同步IO编程中，IO的处理是阻塞式的，简单意思即是处理IO的线程在等待资源的过程中不能去处理其他的事情。这样看起来很浪费，在现实生活中举个例子就是说，我在准备泡一壶茶，在等待开水煮开的过程中却不能够抽身去倒茶叶呀洗茶壶，这样是不是很怪？而且干等着时间也浪费了。如下图所示：
<center>
![阻塞式IO](https://i.imgur.com/B5sJoiA.png)
</center>
然后Java就出现了用于异步操作的NIO（原本应该是New IO的意思，但NIO已面世很久了，所有更多人理解为Non-blocking IO），NIO中使用了buffer、channel、selector等概念，通过selector能够让线程在多个channel之间切换，异步处理多个IO操作。也就是说我能够在等待煮开水的同时，还能去倒茶叶呀、洗茶壶了，优化了资源的利用。如下图所示
<center>
![非阻塞式IO](https://i.imgur.com/zBSBZSh.png)
</center>
但是NIO原生代码直接进行操作比较繁琐，而且容易出现问题，netty则是基于NIO的异步、事件驱动的框架。

## netty特性
netty具有如下特性：  

- 设计：统一的API，支持多种传输类型，包括阻塞和非阻塞的；简单而强大的线程模型；真正的无连接数据报套接字支持；链接逻辑组件以支持复用。
- 性能：拥有比java核心的API更高的吞吐量以及更低的延迟；得益于池化和复用，拥有更低的资源消耗；最少的内存复制
- 健壮性：不会因为慢速、快速或者超载的连接而导致OutOfMemoryError;消除在高速网络中NIO应用程序常见的不公平读/写比例
- 安全性：完整的SSL/TLS以及StartTLS支持

## netty核心组件
1. Channel：NIO最基本也最重要的部分，它代表一个实体（文件、硬件设备等)的开放连接
2. 回调:netty是事件驱动的，在事件发生时netty内部是通过调用回调方法进行相关的处理
3. Future：类似于JDK实现的并发包内的Future,这是用于线程间通信的；Netty内部实现了自己的ChannelFuture进行通知
4. 事件和ChannelHandler：Netty内部是通过使用不同的事件来通知我们状态的改变或者是操作的状态，而channelHandler则定义了各种事件的接口，用户可以实现具体的接口去处理不同的事件。



