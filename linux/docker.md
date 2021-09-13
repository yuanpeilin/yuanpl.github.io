# 安装Docker
```sh
# 配置 docker 镜像加速
$ vi /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
  "registry-mirrors": ["https://m9r2r2uj.mirror.aliyuncs.com"]
}
```

# 镜像
```sh
# 搜索官方仓库镜像
$ docker search centos
$ docker search java

# 根据镜像名称下载镜像
$ docker pull centos
$ docker pull java:8
$ docker pull nginx:1.14

# 查看当前主机镜像列表
$ docker images
$ docker image ls

# 查看镜像的详细信息
$ docker image inspect centos

# 运行镜像
$ docker run hello-world

# 导出镜像
$ docker image save centos > docker-centos.tar.gz

# 导入镜像
$ docker image load -i docker-centos.tar.gz

# 删除镜像
$ docker image rmi centos:latest
```

# 容器
```sh
# 新建并启动容器(local port:container port)
$ docker run -d -p 91:80 nginx:1.14
$ docker run -d -p 91:80 nginx:1.14 -net=bridge
$ docker run -d -p 91:80 nginx:1.14 -net=host
$ docker run -d -p 92:80 java:8

# 列出容器
$ docker ps

# 查看容器信息
$ docker inspect <container id>

# 启动容器
$ docker start <container id>

# 停止容器
$ docker stop <container id>

# 进入容器
$ docker container exec -it <container id> /bin/bash
```

# Dockerfile
```dockerfile
# 构建自己的镜像

### FROM指定基础镜像
FROM nginx
### Run构建镜像阶段执行命令
RUN echo '<h1>Docker Nginx</h1>' > /usr/share/nginx/html/index.html
```

```dockerfile
# 指定基础镜像
FROM java:8
# 复制文件到容器
ADD test.jar /app.jar
# 声明暴露的端口
EXPOSE 8761
# 容器启动后执行的命令
ENTRYPOINT ["java","-jar","/app.jar"]
```

```sh
$ docker build -t nginx:wangq .
$ docker run -d -p 93:80 nginx:wangq
```
