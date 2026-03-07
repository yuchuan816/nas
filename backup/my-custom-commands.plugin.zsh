# ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh
#!/bin/zsh

() {
    # 局部变量定义，函数执行完后自动注销
    local _MY_HOME_DIR="/home/tom"
    local _MY_NAS_DIR="${_MY_HOME_DIR}/code/nas"

    #######################################
    # 媒体文件操作
    #######################################
    alias ucp="zsh ${_MY_NAS_DIR}/utils/cp.zsh"
    alias ucd="source ${_MY_NAS_DIR}/utils/cd.zsh"

    #######################################
    # 代理
    #######################################
    # 设置代理并尝试连接 Google (2秒超时) 以验证是否生效
    alias setp='export https_proxy="http://home.server:20171" http_proxy="http://home.server:20171" all_proxy="socks5://home.server:20170"; echo "代理已开启，正在测试连接..."; curl -I https://www.google.com --connect-timeout 2'
    alias unsetp='unset https_proxy http_proxy all_proxy ALL_PROXY; echo "代理已关闭"'
    # 快速查看当前出口 IP
    alias myip='curl -L ip.p3terx.com'

    #######################################
    # 系统操作
    #######################################
    alias rcp='rsync -avh --progress'
    alias off='echo -n "确定要关机吗? (Y/n): "; read -r ans; [[ -z "$ans" || "$ans" =~ ^[Yy]$ ]] && sudo shutdown now'

    #######################################
    # docker compose 快速操作
    #######################################
    alias dcctl="zsh ${_MY_NAS_DIR}/utils/dcctl.zsh"

    # 设置默认编辑器 (export 在匿名函数中依然具有全局环境效力)
    export VISUAL="nano"
    export EDITOR="nano"
}
