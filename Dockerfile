# 继承docker镜像，带jre的tomcat8
From tomcat:8.0.52-jre8

# 制作者
MAINTAINER zhangyujin

# 设置容器内程序运行的工作目录
WORKDIR /usr/local/tomcat

# 删除ROOT目录
RUN rm -rf webapps/examples && rm -rf webapps/ROOT

# 复制当前工程到容器内的指定目录中
COPY ./public /usr/local/tomcat/webapps/ROOT

# 暴露服务的端口
EXPOSE 8080

# 容器启动后，启动的服务
#CMD
