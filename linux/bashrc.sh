# +----------------------------------+
# |         System Setting           |
# +----------------------------------+
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# History
HISTSIZE=3000
HISTFILESIZE=6000
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# format
HISTTIMEFORMAT='%F %T '
# append to the history file, don't overwrite it
# 多个终端的情况下, 改为追加命令(默认最后的终端会覆盖以前的)
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# +----------------------------------+
# |           common init            |
# +----------------------------------+
export JAVA_HOME='/opt/java8/jdk1.8.0_281'
export PATH=$PATH:$JAVA_HOME/bin
if [[ -d /home/ypl/workspace/yuanpeilin.github.io/linux/alias/ ]];then
    for file in /home/ypl/workspace/yuanpeilin.github.io/linux/alias/*; do
        echo $file
        . $file
    done
    unset file
fi
if [[ -d /home/ypl/workspace/yuanpeilin.github.io/linux/bash_completion/ ]];then
    for file in /home/ypl/workspace/yuanpeilin.github.io/linux/bash_completion/*; do
        echo $file
        . $file
    done
    unset file
fi
[[ -d /home/ypl/workspace/yuanpeilin.github.io/linux/bin/ ]] && PATH=$PATH:/home/ypl/workspace/yuanpeilin.github.io/linux/bin/
[[ -f ~/.bashrc.temp ]] && source ~/.bashrc.temp

clear
todo -l

_git_branch() {
    branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
    [[ "${branch}"x != ""x ]] && echo "($branch)"
}
_ps_color(){
    if (( $? == 0 )); then
        echo '32'
    else
        echo '31'
    fi
}
PS1='\e[01;$(_ps_color)m\w$(_git_branch)\$ \e[0m'

# +----------------------------------+
# |            USER init             |
# +----------------------------------+
export VULTR='144.202.89.76'
export V='144.202.89.76'

alias sv='ssh root@$VULTR'
alias svultr='ssh root@$VULTR'
alias yuanpeilin='cd ~/workspace/yuanpeilin.github.io/ && cdgproj'
alias sql="mysql -uroot -p980620 --prompt='\u@\h [\d]> ' --database=must"

mkcd() {
    mkdir "$1"
    cd "$1"
}

plant_uml_server(){
    cd /opt/plantuml-server
    sudo mvn jetty:run -Djetty.port=9999 &>/dev/null &
}

mc() {
    fcitx_pids=$(ps -ef | grep fcitx | awk '{print $2}' | tr '\n' ' ')
    echo "${fcitx_pids}"
    for pid in $fcitx_pids; do
        kill $pid
    done
    unset fcitx_pids pid
    cd ~
    java -jar /opt/hmcl/HMCL-3.3.172.jar &>/dev/null &
}

