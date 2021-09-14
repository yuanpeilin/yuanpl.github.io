* [systemd命令群](#systemd命令群)
    - [systemctl](#systemctl)
    - [systemd-analyze](#systemd-analyze)
    - [hostnamectl](#hostnamectl)
    - [journalctl](#journalctl)
    - [localectl](#localectl)
    - [loginctl](#loginctl)
    - [timedatectl](#timedatectl)
* [Unit](#unit)
    - [Unit种类](#unit种类)
    - [列出Unit](#列出unit)
    - [查看Unit状态](#查看unit状态)
    - [管理Unit](#管理unit)
    - [查看Unit依赖关系](#查看unit依赖关系)
    - [Unit配置文件](#unit配置文件)
    - [Unit配置文件区块](#unit配置文件区块)
    - [Unit例子](#unit例子)
* [Target](#target)
    - [Target相关命令](#target相关命令)
    - [与init关系](#与init关系)



***************************************************************************************************
***************************************************************************************************



# systemd命令群
### systemctl
systemctl是systemd的主命令, Unit有关部分参见[Unit](#unit)

```sh
# 查看Systemd的版本
$ systemctl --version

# 重启系统
$ sudo systemctl reboot

# 关闭系统, 切断电源
$ sudo systemctl poweroff

# CPU停止工作
$ sudo systemctl halt

# 暂停系统
$ sudo systemctl suspend

# 让系统进入冬眠状态
$ sudo systemctl hibernate

# 让系统进入交互式休眠状态
$ sudo systemctl hybrid-sleep

# 启动进入救援状态(单用户状态)
$ sudo systemctl rescue
```

### systemd-analyze
```sh
# 查看启动耗时
$ systemd-analyze

# 查看每个服务的启动耗时
$ systemd-analyze blame

# 显示瀑布状的启动过程流
$ systemd-analyze critical-chain

# 显示指定服务的启动流
$ systemd-analyze critical-chain atd.service
```

### hostnamectl
```sh
# 显示当前主机的信息
$ hostnamectl

# 设置主机名
$ sudo hostnamectl set-hostname rhel7
```

### journalctl
日志的配置文件是 */etc/systemd/journald.conf*

```sh
# 查看所有日志(默认情况下, 只保存本次启动的日志)
$ journalctl

# 查看内核日志(不显示应用日志)
$ journalctl -k

# 查看系统本次启动的日志
$ journalctl -b
$ journalctl -b -0

# 查看上一次启动的日志(需更改设置)
$ journalctl -b -1

# 查看指定时间的日志
$ journalctl --since="2012-10-30 18:17:16"
$ journalctl --since "20 min ago"
$ journalctl --since yesterday
$ journalctl --since "2015-01-10" --until "2015-01-11 03:00"
$ journalctl --since 09:00 --until "1 hour ago"

# 显示尾部的最新10行日志
$ journalctl -n

# 显示尾部指定行数的日志
$ journalctl -n 20

# 实时滚动显示最新日志
$ journalctl -f

# 查看指定服务的日志
$ journalctl /usr/lib/systemd/systemd

# 查看指定进程的日志
$ journalctl _PID=1

# 查看某个路径的脚本的日志
$ journalctl /usr/bin/bash

# 查看指定用户的日志
$ journalctl _UID=33 --since today

# 查看某个Unit的日志
$ journalctl -u nginx.service
$ journalctl -u nginx.service --since today

# 实时滚动显示某个Unit的最新日志
$ journalctl -u nginx.service -f

# 合并显示多个Unit的日志
$ journalctl -u nginx.service -u php-fpm.service --since today

# 查看指定优先级(及其以上级别)的日志, 共有8级
# 0: emerg
# 1: alert
# 2: crit
# 3: err
# 4: warning
# 5: notice
# 6: info
# 7: debug
$ journalctl -p err -b

# 日志默认分页输出, --no-pager 改为正常的标准输出
$ journalctl --no-pager

# 以 JSON 格式(单行)输出
$ journalctl -b -u nginx.service -o json

# 以 JSON 格式(多行)输出, 可读性更好
$ journalctl -b -u nginx.serviceqq -o json-pretty

# 显示日志占据的硬盘空间
$ journalctl --disk-usage

# 指定日志文件占据的最大空间
$ journalctl --vacuum-size=1G

# 指定日志文件保存多久
$ journalctl --vacuum-time=1years
```

### localectl
```sh
# 查看本地化设置
$ localectl

# 设置本地化参数
$ sudo localectl set-locale LANG=en_GB.utf8
$ sudo localectl set-keymap en_GB
```

### loginctl
```sh
# 列出当前session
$ loginctl list-sessions

# 列出当前登录用户
$ loginctl list-users

# 列出显示指定用户的信息
$ loginctl show-user ruanyf
```

### timedatectl
```sh
# 查看当前时区设置
$ timedatectl

# 显示所有可用的时区
$ timedatectl list-timezones

# 设置当前时区
$ sudo timedatectl set-timezone America/New_York
$ sudo timedatectl set-time YYYY-MM-DD
$ sudo timedatectl set-time HH:MM:SS

# 将硬件时钟设为本地实际时间(RTC称为硬件时钟或BIOS时钟, 位于主板硬件上. Linux认为RTC存储UTC)
$ sudo timedatectl set-local-rtc 1
```

# Unit
### Unit种类
Systemd 可以管理所有系统资源, 不同的资源统称为Unit, 一共11种
* **Service Unit** 系统服务
* **Socket Unit** 进程间通信的socket
* [**Target Unit**](#target) 多个Unit构成的一个组
* **Device Unit** 硬件设备
* **Mount Unit** 文件系统的挂载点
* **Automount Unit** 自动挂载点
* **Timer Unit** 定时器
* **Swap Unit** swap文件
* **Path Unit** 文件或路径
* **Slice Unit** 进程组
* **Scope Unit** 不是由Systemd启动的外部进程

### 列出Unit
```sh
# 列出正在运行的Unit
$ systemctl list-units

# 列出所有Unit, 包括没有找到配置文件的或者启动失败的
$ systemctl list-units --all

# 列出所有没有运行的Unit
$ systemctl list-units --all --state=inactive

# 列出所有加载失败的Unit
$ systemctl list-units --failed

# 列出所有正在运行的, 类型为Service的Unit
$ systemctl list-units --type=service
```

### 查看Unit状态
```sh
# 显示系统状态
$ systemctl status

# 显示单个Unit的状态
$ sysystemctl status bluetooth.service

# 显示远程主机的某个Unit的状态
$ systemctl -H root@rhel7.example.com status httpd.service


# 显示某个Unit是否正在运行
$ systemctl is-active application.service

# 显示某个Unit是否处于启动失败状态
$ systemctl is-failed application.service

# 显示某个Unit服务是否建立了启动链接
$ systemctl is-enabled application.service
```

### 管理Unit
```sh
# 激活开机自启动, 会建立实际文件到/etc/systemd/system/的符号链接
$ systemctl enable xxxx.service

# 撤销开机自启动, 会删除/etc/systemd/system/下的文件
$ systemctl disable xxxx.service

# 启动一个服务
$ sudo systemctl start apache.service

# 停止一个服务
$ sudo systemctl stop apache.service

# 重启一个服务
$ sudo systemctl restart apache.service

# 杀死一个服务的所有子进程
$ sudo systemctl kill apache.service
```

### 查看Unit依赖关系
```sh
# 列出一个Unit的所有依赖
$ systemctl list-dependencies nginx.service

# 有些依赖是Target类型, 展开Target类型依赖
$ systemctl list-dependencies --all nginx.service
```

### Unit配置文件
* 配置文件的后缀名就是[Unit的种类](#unit种类), 如果省略默认后缀名为.service, 所以sshd会被理解成sshd.service
* Systemd默认从目录 */etc/systemd/system/* 和 */lib/systemd/system/* 读取配置文件, etc目录下存放的大部分文件都是符号链接, lib目录才是真正放配置文件的地方
* 查看Unit状态需使用`systemctl status`, 而配置文件与Unit状态不同, 需用`list-unit-files`, 每个配置文件一共有四种状态
    - **enabled** 已建立启动链接
    - **disabled** 没建立启动链接
    - **static** 该配置文件没有`[Install]`部分, 无法执行, 只能作为其他配置文件的依赖
    - **masked** 该配置文件被禁止建立启动链接

```sh
# 查看配置文件的内容
$ systemctl cat xxxx.service

# 显示某个Unit的所有底层参数
$ systemctl show httpd.service

# 显示某个Unit的指定属性的值
$ systemctl show -p CPUShares httpd.service

# 设置某个Unit的指定属性
$ sudo systemctl set-property httpd.service CPUShares=500


# 重新加载一个服务的配置文件(新增或修改配置文件后重载才生效)
$ sudo systemctl reload apache.service

# 重载所有修改过的配置文件(新增或修改配置文件后重载才生效)
$ sudo systemctl daemon-reload


# 列出所有配置文件及状态
$ systemctl list-unit-files

# 列出指定类型的配置文件及状态
$ systemctl list-unit-files --type=service
```

### Unit配置文件区块
* **`[Unit]`** 此区块通常是配置文件的第一个区块, 用来定义Unit的元数据, 以及配置与其他Unit的关系
    - `Description` 简短描述
    - `Documentation` 文档地址
    - `Requires` 强依赖, 当前Unit依赖的其他Unit, 如果它们没有运行, 当前Unit会启动失败
    - `Wants` 弱依赖, 与当前Unit配合的其他Unit, 如果它们没有运行, 当前Unit不会启动失败
    - `BindsTo` 与Requires类似, 它指定的Unit如果退出, 会导致当前Unit停止运行
    - `Before` 如果该字段指定的Unit也要启动, 那么必须在当前Unit之后启动, 与依赖无关
    - `After` 如果该字段指定的Unit也要启动, 那么必须在当前Unit之前启动, 与依赖无关
    - `Conflicts` 这里指定的Unit不能与当前Unit同时运行
    - `Condition...` 当前Unit运行必须满足的条件, 否则不会运行
    - `Assert...` 当前Unit运行必须满足的条件, 否则会报启动失败
* **`[Service]`** 启动行为区块, 只有Service类型的Unit才有这个区块. 在所有的启动设置之前都可以加上一个`-`, 发生错误的时候不影响其他命令的执行
    - `Type` 定义启动时的进程行为, 它有以下几种值
        - `simple` 默认值, 执行ExecStart指定的命令, 启动主进程
        - `forking` 以`fork`方式从父进程创建子进程, 创建后父进程会立即退出
        - `oneshot` 一次性进程, Systemd会等当前服务退出, 再继续往下执行
        - `dbus` 当前服务通过D-Bus启动
        - `notify` 当前服务启动完毕, 会通知Systemd, 再继续往下执行
        - `idle` 若有其他任务执行完毕, 当前服务才会运行
    - `KillMode` 定义Systemd如何停止服务
        - control-group 默认值, 当前控制组里面的所有子进程, 都会被杀掉
        - process 只杀主进程
        - mixed 主进程将收到[SIGTERM信号](command.md/#常用信号), 子进程收到[SIGKILL信号](command.md/#常用信号)
        - none 没有进程会被杀掉, 只是执行服务的stop命令
    - `Restart` 定义Systemd重启服务的方式
        - `no` 默认值, 退出后不会重启
        - `always` 不管是什么退出原因, 总是重启
        - `on-success` 服务正常退出时(退出状态码为0), 服务就将重启
        - `on-failure` 非正常退出时(退出状态码非0), 服务就将重启
        - `on-abnormal` 只有被信号终止和超时, 才会重启
        - `on-abort` 只有在收到没有捕捉到的信号终止时, 才会重启
        - `on-watchdog` 超时退出, 才会重启
    - `ExecStart` 启动当前服务的命令
    - `ExecStartPre` 启动当前服务之前执行的命令
    - `ExecStartPost` 启动当前服务之后执行的命令
    - `ExecReload` 重启当前服务时执行的命令
    - `ExecStop` 停止当前服务时执行的命令
    - `ExecStopPost` 停止当其服务之后执行的命令
    - `RestartSec` 自动重启当前服务间隔的秒数
    - `TimeoutSec` 定义Systemd停止当前服务之前等待的秒数
    - `Environment` 指定环境变量
* **`[Install]`** 通常是配置文件的最后一个区块, 用来定义如何启动, 以及是否开机启动
    - `WantedBy` 它的值是一个或多个Target, 当前Unit激活时(enable)符号链接会放入/etc/systemd/system目录下面以 *Target名 + .wants* 构成的子目录中
    - `RequiredBy` 它的值是一个或多个Target, 当前Unit激活时, 符号链接会放入/etc/systemd/system目录下面以 *Target名 + .required* 构成的子目录中
    - `Alias` 当前Unit可用于启动的别名
    - `Also` 当前Unit激活(enable)时, 会被同时激活的其他Unit

### Unit例子
```
# /lib/systemd/system/ypl.service
[Unit]
Description=ruanyf test
After=default.target

[Service]
Type=oneshot
ExecStart=/home/ypl/workspace/yuanpeilin.github.io/temp/qq.sh

[Install]
WantedBy=default.target
```

```
# /lib/systemd/system/nginx.service
[Unit]
Description=nginx
After=default.target

[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit

[Install]
WantedBy=default.target
```

# Target
Target 就是一个Unit组, 包含许多相关的Unit, 启动某个Target的时候Systemd就会启动里面所有的Unit

### Target相关命令
```sh
# 查看当前系统的所有Target
$ systemctl list-unit-files --type=target

# 查看一个Target包含的所有Unit
$ systemctl list-dependencies multi-user.target

# 查看启动时的默认Target
$ systemctl get-default

# 设置启动时的默认Target
$ sudo systemctl set-default graphical.target

# 切换Target时, 默认不关闭前一个Target启动的进程, systemctl isolate 命令改变这种行为, 
# 关闭前一个Target里面所有不属于后一个Target的进程
$ sudo systemctl isolate multi-user.target
```

### 与init关系
* 启动脚本的位置
    - init存放在 */etc/init.d* 目录, 符号链接到不同的RunLevel目录, 比如 */etc/rc3.d*
    - systemd存放在 */lib/systemd/system* 目录, 符号链接到 */etc/systemd/system* 目录
* 配置文件的位置
    - init进程的配置文件是 */etc/inittab* , 各种服务的配置文件存放在 */etc/sysconfig* 目录
    - systemd的配置文件主要存放在 */lib/systemd* 目录
* 并发
    - init是串行化的
    - systemd可以并行启动服务
* 运行级别
    - init的[runlevel](command.md/#runlevel)是互斥的, 只能有一个runlevel
    - systemd可以启动多个Target, 默认为 */lib/systemd/system/default.target* , 通常符号链接到graphical.target或multi-user.target

runlevel   | Symbolically link | target name
---------- | ----------------- | -----------
Runlevel 0 | runlevel0.target  | poweroff.target
Runlevel 1 | runlevel1.target  | rescue.target
Runlevel 2 | runlevel2.target  | multi-user.target
Runlevel 3 | runlevel3.target  | multi-user.target
Runlevel 4 | runlevel4.target  | multi-user.target
Runlevel 5 | runlevel5.target  | graphical.target
Runlevel 6 | runlevel6.target  | reboot.target