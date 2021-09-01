# 文件结构
```
.ssh/                 权限为700
├── authorized_keys   权限必须为600
├── id_rsa            权限必须为600
├── id_rsa.pub
└── known_hosts
```

# ssh
### 语法
- `-t` 分配TTY, 执行远程命令使用

### 配置
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

# ssh-keygen
### 语法
- `-C <comment>` 注释
- `-E <type>` 指定指纹的显示方式, 有**SHA256** **RSA**两种, 默认为SHA256
- `-f <file path>` 指定密钥路径
- `-l` 显示公钥的指纹
- `-N <pass phrase>` 提供新密码
- `-P <pass phrase>` 提供旧密码
- `-p` 修改密码
- `-R` 移除服务器指纹
- `-t <type>` 指定新密钥生成类型, 有 **dsa** **ecdsa** **ed25519** **rsa**
- `-v` 显示指纹的图形

### 例子
* `ssh-keygen -t rsa -N 'password' -C 'comment' -f id_rsa` 生成新密钥
* `ssh-keygen -p -f id_rsa` 修改密钥的密码
* `ssh-keygen -p -P 'old paaword' -N 'new password' -f id_rsa` 修改密钥的密码
* `ssh-keygen -E MD5 -l -f id_rsa.pub` 打印指纹
* `ssh-keygen -E SHA256 -lv -f id_rsa.pub` 打印指纹并显示图像
* `ssh-keygen -f "/home/ypl/.ssh/known_hosts" -R "20.14.71.18"` 移除已知的服务器指纹

# ssh-keyscan
获取公钥信息

### 语法
- `-t <type>` 指定获取公钥的类型, 有 **dsa** **ecdsa** **ed25519** **rsa**

### 例子
* `ssh-keyscan -t ecdsa 192.168.0.1` 获取公钥
