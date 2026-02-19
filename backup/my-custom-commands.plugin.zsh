# ~/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh

HOME_DIR="/home/tom/"
NAS_DIR="$HOME_DIR/code/nas/"

#######################################
# 媒体文件操作
#######################################
alias ucp="zsh $NAS_DIR/utils/cp.zsh"
alias ucd="source $NAS_DIR/utils/cd.zsh"

#######################################
# 代理
#######################################
alias setp='export https_proxy="http://home.server:20171";export http_proxy="http://home.server:20171";export all_proxy="socks5://home.server:20170";'
alias unsetp='unset https_proxy; unset http_proxy; unset all_proxy; unset ALL_PROXY;'

#######################################
# 系统操作
#######################################
alias hdsleep='sudo hdparm -S 120 /dev/sda /dev/sdc /dev/sdd'
alias hdstate='sudo hdparm -C /dev/sda /dev/sdc /dev/sdd'
alias off='sudo shutdown now'
alias apt-purge-all='sudo apt purge $@ && sudo apt autoremove --purge -y'
alias m='micro'

#######################################
# docker compose 快速操作
#######################################
alias dcctl="zsh $NAS_DIR/utils/dcctl.zsh"

