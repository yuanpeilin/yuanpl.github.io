# 文件结构
```
.ssh/                 权限为700
├── authorized_keys   权限必须为600
├── config            用户配置文件
├── id_rsa            权限必须为600
├── id_rsa.pub
└── known_hosts
```

# 配置
* 客户端配置文件位于 */etc/ssh/ssh_config*
* 服务器配置文件位于 */etc/ssh/sshd_config*

```sh
PermitRootLogin no # 禁止root登录
ClientAliveInterval 600 # 断线重连时间
MaxAuthTries 3 # 最大尝试次数
PasswordAuthentication no # 禁止密码登录
PermitEmptyPasswords no # 禁止空白密码登录
PubkeyAuthentication yes # 使用密钥登录
```

# ssh
### 语法
* `-C` 压缩数据进行传输
* `-D <port>` [**动态转发**](#动态转发) 该端口收到的请求, 都转发到SSH服务器
* `-f` ssh链接在后台运行, 主要用于端口转发
* `-F <path>` 指定配置文件
* `-i <path>` 指定私钥, 默认为 *~/.ssh/id_rsa*
* `-l <username>` 指定用户名
* `-L <port1>:<server:port2>` [**本地转发**](#本地转发) 所有发向本地port1端口的请求, 都会通过SSH服务器发往server的port2端口, 相当于直接连上了server的port2端口
* `-N` 只进行动态转发, 不登录SSH服务器
* `-p <port>` 指定端口
* `-R <port1>:<server:port2>` [**远程转发**](#远程转发) 一般在SSH服务器执行, 所有发向本地port1端口的请求, 都会转发往server的port2端口
* `-t` 分配TTY(交互式shell), 执行远程命令使用

# ssh-copy-id
### 语法
- `-i <path>` 指定公钥位置

# ssh-keygen
### 语法
* `-C <comment>` 注释
* `-f <path>` 指定密钥路径
* `-F <host>` 检查known_hosts文件中是否包含host的公钥
* `-l` 显示公钥的指纹
* `-N <pass phrase>` 提供新密码
* `-P <pass phrase>` 提供旧密码
* `-p` 修改密码
* `-R <host>` 移除SSH服务器指纹
* `-t <type>` 指定新密钥生成类型, 有 **dsa** **ecdsa** **ed25519** **rsa**
* `-v` 显示指纹的图形

### 例子
```sh
$ ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub # 打印指纹
$ ssh-keygen -lv -f /etc/ssh/ssh_host_rsa_key.pub # 打印指纹并显示图像
$ ssh-keygen -p -f id_rsa # 修改密钥的密码
$ ssh-keygen -p -P 'old paaword' -N 'new password' -f id_rsa # 修改密钥的密码
$ ssh-keygen -R "20.14.71.18" -f known_hosts # 移除已知的服务器指纹
$ ssh-keygen -t rsa -N 'password' -C 'comment' -f id_rsa # 生成新密钥
```

# ssh-keyscan
获取公钥信息

### 语法
- `-t <type>` 指定获取公钥的类型, 有 **dsa** **ecdsa** **ed25519** **rsa**

### 例子
* `ssh-keyscan -t ecdsa 192.168.0.1` 获取公钥

# 端口转发
端口转发(port forwarding)又成为SHH隧道(SSH tunnel), 共有三种类型:
* [动态转发](#动态转发)
* [本地转发](#本地转发)
* [远程转发](#远程转发)

### 动态转发
动态转发(Dynamic Forwarding): 本地与SSH服务器建立加密连接, 本地某个端口的通信, 都通过加密连接转发到SSH服务器, 至于SSH服务器要访问哪里, 完全是**动态**的, 取决于本地的原始通信

动态转发采取的是SOCK5协议, 某些软件需要设置SOCK5代理服务器才行

本地指定端口的通信变成SSH服务器的通信, 主要用于fq

```sh
# 本地1080端口的通信都动态转发到SSH服务器
$ ssh -Nf -D 1080 root@10.xx.xx.xx
```

### 本地转发
本地转发(Local Forwarding): SSH服务器做为跳板机, 建立本地主机与目标主机的加密连接. 访问本地的指定端口, 等同样访问目标主机的指定端口, 即本地端口绑定目标主机指定端口

本地转发采取的是HTTP协议

将目标主机端口映射为本地端口, 主要用于加密

```sh
# 访问本地的local-port端口, 等同于访问targer-host的target-port端口
# 本地的local-port端口的所有请求, 都会转发到跳板机ssh-host, 跳板机再将请求发送到target-host的target-port端口
$ ssh -Nf -L local-port:targer-host:target-port root@ssh-host
```

### 远程转发
远程转发, 设置远程服务器的端口规则

将目标主机端口映射为远程主机端口, 主要用于内网穿透

```sh
# 访问ssh-host:ssh-host-port等同于访问target-host:target-port
# ssh-host的ssh-host-port端口的所有请求, 都会转发到跳板机(执行此命令的机器), 跳板机再将请求发送到target-host的target-port端口
$ ssh -Nf -R ssh-host-port:target-host:target-port root@ssh-host
```
