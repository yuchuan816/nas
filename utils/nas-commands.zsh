#!/bin/zsh

# 使用 readonly 确保安全，不污染后续的写入操作
readonly _MY_HOME_DIR="/home/tom"
readonly _MY_NAS_DIR="${_MY_HOME_DIR}/nas"

#######################################
# 文件复制操作
#######################################
alias ucp="zsh ${_MY_NAS_DIR}/utils/cp.zsh"

#######################################
# docker compose 快速操作
#######################################
alias dcctl="zsh ${_MY_NAS_DIR}/utils/dcctl.zsh"

#######################################
# 关机操作
#######################################
off() {
    echo -n "确定要关机吗? (Y/n): "
    read -r ans
    if [[ -z "$ans" || "$ans" =~ ^[Yy]$ ]]; then
        local backup_script="${_MY_NAS_DIR}/utils/backup.zsh"
        echo "$backup_script"
        if [[ -f "$backup_script" ]]; then
            echo "正在执行关机前备份..."
            zsh "$backup_script"
        fi
        sudo shutdown now
    fi
}
