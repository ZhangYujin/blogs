---
title: 生产环境下的Node.js-npm最佳实践
date: 2017-10-28 11:50:19
tags: 
- NodeJs
categories:
- 编程
- 翻译
- NodeJS系列
---
> Node Hero是一个最基本的Node.js最佳实践的教程系列，因此各位可以通过使用它来开发应用  

在新系列的教程，**生产环境下的Node.js**中，我们正在编写一系列针对公司里更大Node.js应用的需求和那些已经有一定Node.js基础的开发者们的文章。  
在**生产环境下的Node.js**第一章里面，你将会学习到使用npm的最佳时间，同时学到一些能在日常使用中帮你节省大量时间的建议和技巧。  
**即将上线的生产环境下的Node.js系列中的章节**   

- 使用npm  
  - npm使用建议和最佳时间（你正在阅读的这篇）
  - [版本和模块发布]("https://blog.risingstack.com/nodejs-at-scale-npm-publish-tutorial")
  - [理解模块系统，CommonJS和require]("https://blog.risingstack.com/node-js-at-scale-module-system-commonjs-require")
- Node.js内部实现深入挖掘  
  - [Node.js事件循环]("https://blog.risingstack.com/node-js-at-scale-understanding-node-js-event-loop/")
  - [Node.js垃圾回收阐述]("https://blog.risingstack.com/node-js-at-scale-node-js-garbage-collection/")
  - 编写原生模块  
- 构建
  - 结构化Node.js应用
  - 代码清洁
  - 掌握异步
  - 事件消息传递
  - 命令查询责任分离
- 测试
  - 单元测试
  - 端到端测试
- 产品中的Node.js
  - 监控Node.js应用
  - 调试Node.js应用
  - Node.js应用性能分析
- 微服务
  - 请求认证
  - 分布式追踪
  - API网关  
  
--- 
## npm最佳实践 

使用npm cli最普遍的方式是`npm install`,但它还有许多使用方式。在**生产环境下的Node.js**这一章中，你将会学习到npm在应用的整个生命周期中能如何帮助你-从开始一个新的项目到开发和发布。
## 0 了解你的npm
在深入这些主题之前，我们来看看一些能帮助你查看你正在运行的npm 的版本，或者什么命令是可用的。
### npm版本
```
$ npm --version  
2.13.2  
```

npm不止能够返回自身的版本-它还能返回当前包的版本，正在使用的Node.js版本以及OpenSSL或者V8引擎的版本：
```
$ npm version
{ bleak: '1.0.4',  
  npm: '2.15.0',  
  ares: '1.10.1-DEV',  
  http_parser: '2.5.2',  
  icu: '56.1',  
  modules: '46',  
  node: '4.4.2',  
  openssl: '1.0.2g',  
  uv: '1.8.0',  
  v8: '4.5.103.35',  
  zlib: '1.2.8' }  
```
### npm help
正如多数命令行工具，npm也拥有一个不错的内置帮助功能。描述和概要通常是可用的，这些是基本的[手册页面]("https://www.kernel.org/doc/man-pages/")。
```
$ npm help test
NAME  
       npm-test - Test a package

SYNOPSIS  
           npm test [-- <args>]

           aliases: t, tst

DESCRIPTION  
       This runs a package's "test" script, if one was provided.

       To run tests as a condition of installation, set the npat config to true.
```
## 1 使用`npm init`开始新的项目  
开始新的项目时，`npm init`通过交互生成一个`package.json`文件能够帮助你很多。它通过给出示例的提问方式来设置项目的名称或者描述。不过，这还有一个更加快速的解决方法！
```
$ npm init --yes
```
如果你使用`npm init --yes`，它将不会给出提示，只是创建一个默认的`package.json`。你能够通过以下命令来设置这些默认的信息：
```
npm config set init.author.name YOUR_NAME  
npm config set init.author.email YOUR_EMAIL  
```
## 2 查找npm包
查找合适的包是相当具有挑战的，这里拥有数十万计的模块供你选择。从我们的经验以及从我们最新的[Node.js调查]("https://blog.risingstack.com/node-js-developer-survey-results-2016/")能告诉我们，选择正确的npm包是很容易让人失望的。让我们尝试去选择一个能帮助我们发送http请求的模块。
[npms.io]("https://npms.io/")是一个能让这个挑战变得更加简单的网站。它提供了质量、受欢迎度和维护等度量方式。这些是通过是否一个模块有过时的依赖、是否有连接器配置、是否覆盖了测试或者最近的提交是在什么时候来计算的。
## 3 研究npm包
一旦我们选定了模块（比如我们例子中的`request`模块），我们应该看看相关的文档，并且检查下公开的问题来衡量在我们的应用中应该需要什么。别忘了你使用的npm包越多，你选到一个有缺陷或者恶意的包的风险就越大。如果你想了解更多关于[npm关联的安全风险]("https://blog.risingstack.com/controlling-node-js-security-risk-npm-dependencies/")，并阅读我们相关的参考。
如果你想使用命令行打开模块的首页，你能这么做：
```
$ npm home request
```
为查看公开的问题或者开放可用的路线图（如果它有的话），你能这样试试：
```
$ npm bugs request
```
如果你想检查一个模块的git仓库，作为一个选择你可以这样：
```
$ npm repo request
```
## 4 保存依赖
一旦找到你想要在你项目中引入的包，你就需要安装并且保留它。最常用的方法就是`npm install request`。
如果你想更近一步并且自动的添加到你的package.json文件中，你能这样：
```
$ npm install request --save
```
npm将会默认的添加`^`前缀来保留你的依赖。这意味着在下次`npm install`时最新的无冲突主版本模块将会被安装。若要改变这种行为，你能这样：
```
$ npm config set save-prefix='~'
```
万一你想保存准确的版本，你能这样：
```
$ npm config set save-exact true
```
## 5 封闭依赖
即使你像前面章节那样使用准确的版本号来保存模块，但你也应该知道多数的npm模块的作者并不会这么做。这通常是好的，他们能够因此而自动地获取到补丁和特性。
环境能够对产品部署很轻易的产生问题：如果这时有人刚发布了一个新的版本，**有可能本地需要的版本以来跟产品下的不一样**。当新的版本有一些bug会影响到你的产品体系，问题将会大幅提升。
为了解决这个问题，你可能需要用到`npm shrinkwrap`。它将生成一个`npm-shrinkwrap.json`文件，这个文件不仅包含着你机器上安装的模块的准确岸版本，同时还有它们所依赖的模块版本等。一旦你把这个文件放在适当的位置，`npm install`将会重建依赖树。
## 6 检查过时的依赖
为了检查过时的依赖，npm有个内置的工具方法`npm outdated`。你必须在想进行检测的目录下运行这个命令。
```
$ npm outdated
conventional-changelog    0.5.3   0.5.3   1.1.0  @risingstack/docker-node  
eslint-config-standard    4.4.0   4.4.0   6.0.1  @risingstack/docker-node  
eslint-plugin-standard    1.3.1   1.3.1   2.0.0  @risingstack/docker-node  
rimraf                    2.5.1   2.5.1   2.5.4  @risingstack/docker-node  
```
一旦你维护越来越多的项目，维持所有项目的依赖更新将会是一个很困难的工作。为了自动化这项工作，你能使用[Greenkeeper]("http://greenkeeper.io/")，在一个依赖有更新时自动的发送pull请求到你的仓库中。
## 7 不要在产品中使用`devDepenendencies`
开发依赖之所以这么称呼是为了一个原因，你不需要在产品中安装他们。你在产品中使用的有安全问题的模块会更少，这将使你的人工部署产品更加小而且更加安全。
只安装产品依赖，运行这个：
```
$ npm install --production
```
或者，你能为产品设置`NODE_ENV`环境变量：
```
$ NODE_ENV=production npm install
```
# 8 使你的项目和令牌变得安全
在npm中使用登陆用户，你的npm令牌将会放到`.npmrc`文件中。正如许多开发者在GitHub中存放dotfiles文件，有时这些令牌会一不小心发布出去。现在，在GitHub中查找`.npmrc`文件将会查到数以千计的结果，其中很大一部分包含了令牌。**如果在你的仓库中有dotfiles文件，请再次确认你的证书没有被push上去**。
另一个安全问题的可能来源是意外的把某些文件发布到npm上面。默认情况下npm遵循`.npmignore`文件，并且文件中匹配的那些规则将不进行发布。如果你添加了一个`.npmignore`文件，它将覆盖掉原来的`.npmignore`文件的内容，因此他们是不会合并的。
## 9 开发npm包
当在本地开发包时，你通常会希望在发布到npm前在自己项目中试验一下。这时`npm link`派上用场。
`npm link`能做的就是在全局文件夹中创建一个符号链接用于关联`npm link`运行所在的包。
你能通过运行`npm link package-name`从另一个位置，去创建一个从全局安装的`package-name`到`/node_modules`目录的符号链接。
让我们用实例来展示下：
```
# create a symlink to the global folder
/projects/request $ npm link

# link request to the current node_modules
/projects/my-server $ npm link request

# after running this project, the require('request') 
# will include the module from projects/request
```

# 在生产环境下的Node.js的下一章是：版本和模块发布
生产环境下的Node.js的下一篇文章是[版本深入挖掘，如何发布Node.js模块]("https://blog.risingstack.com/nodejs-at-scale-npm-publish-tutorial")

