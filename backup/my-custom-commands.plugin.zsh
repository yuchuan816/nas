# ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh

_MY_HOME_DIR="/home/tom"
_MY_NAS_DIR="$_MY_HOME_DIR/code/nas"

#######################################
# 媒体文件操作
#######################################
alias ucp="zsh $_MY_NAS_DIR/utils/cp.zsh"
alias ucd="source $_MY_NAS_DIR/utils/cd.zsh"

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
alias hdsleep='sudo hdparm -S 120 /dev/sda /dev/sdc /dev/sdd'
alias hdstate='sudo hdparm -C /dev/sda /dev/sdc /dev/sdd'

# 关机二次确认
alias off='echo -n "确定要关机吗? (y/N): "; read ans; [[ "$ans" == "y" || "$ans" == "Y" ]] && sudo shutdown now'
alias apt-purge-all='sudo apt purge $@ && sudo apt autoremove --purge -y'

#######################################
# docker compose 快速操作
#######################################
alias dcctl="zsh $_MY_NAS_DIR/utils/dcctl.zsh"

# 执行完成后清理局部变量
unset _MY_HOME_DIR
unset _MY_NAS_DIR


