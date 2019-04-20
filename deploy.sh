#!/bin/bash

# 更新当前项目
git pull

# 更新nodejs包
npm install

# hexo重新进行编译，打包出静态文件
hexo generate

# docker根据Dockerfile进行打包
time=$(date "+%Y%m%d_%H%M%S")
tag='portal_'$time

docker build -t focsim.com/blog:$tag .

# 将原来部署的版本下线，并上线最新版本
docker stop blog

docker rm blog

docker run  -p 8080:8080 --name blog -d  focsim.com/blog:$tag 
