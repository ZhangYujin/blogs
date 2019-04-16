---
title: windows下Nginx搭建rtmp视频流环境
date: 2017-03-13 10:50:19
tags: 
- Nginx
- rtmp
categories:
- 编程
- 技术实战
- 杂记
---
> 本文只是介绍一种本人亲测可用的Nginx搭建rtmp视频流的方式 

## 测试环境 
- windows 7 64位
- [nginx 1.7.11.3 Gryphon][1]
- [nginx-rtmp-module][2]
- [ffmpeg][3]  （20170214 win64）
- [VideoLAN][4]

nginx 1.7.11.3 Gryphon,在[NGINX for Windows][1]进行下载,这里下载的Nginx由于集成了一些插件等，能够更加方便的在windows下进行使用。  
nginx-rtmp-module则是Nginx能够扩展到rtmp视频流的插件 　　　FFmpeg:FFmpeg是一套可以用来记录、转换数字音频、视频，并能将其转化为流的开源计算机程序  

## 搭建过程与步骤

1. 首先下载好nginx和nginx-rtmp-module并解压,以及安装ffmpeg(ffmpeg安装过程自行google）
2. 将解压后的nginx-rtmp-module放到nginx目录下![](http://i.imgur.com/wmNa4Mo.png)
3. 在nginx目录下conf文件夹新建**nginx-win-rtmp.conf**,并加入以下代码：
``` 
worker_processes  2;
events {
    worker_connections  8192;
}
rtmp {
    server {
        listen 1935;
        chunk_size 4000;
        application cameragun {
             live on;
        }
    }
}
http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        off;

    server_names_hash_bucket_size 128;

    client_body_timeout   10;
    client_header_timeout 10;
    keepalive_timeout     30;
    send_timeout          10;
    keepalive_requests    10;

    server {
        listen       80;
        server_name  localhost;


        location /stat {
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
        }
        location /stat.xsl {
            root nginx-rtmp-module/;
        }
        location /control {
            rtmp_control all;
        }

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
} 
```
4. cmd进入nginx目录，使用命令`nginx.exe -c conf\nginx-win-rtmp.conf`命令启动nginx
5. 打开浏览器，输入localhost检查是否启动了nginx，若未正确启动，查看nginx目录下logs目录中的日志判断异常
6. 正确启动后，基本的nginx rtmp视频流环境基本搭建完成；通过使用ffmpeg进行视频流的转发来验证视频流是否运行正常![](http://i.imgur.com/nSLtRdf.png)
7. 推送视频流以后，使用VideoLAN接收视频流，查看推送的视频![](http://i.imgur.com/IAtRHUg.png) ![](http://i.imgur.com/uEiSJ40.png)










[1]:http://nginx-win.ecsds.eu/download/ "Nginx download"
[2]:https://github.com/arut/nginx-rtmp-module "nginx-rtmp-module"
[3]:http://ffmpeg.org/ "ffmpeg"
[4]:http://www.videolan.org/vlc/stats/downloads.html "VideoLAN download"


