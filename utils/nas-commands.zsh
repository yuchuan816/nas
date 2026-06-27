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

# 批量控制与硬盘相关的 Docker 服务，以允许机械硬盘正常休眠。
dcctl_hdd_dep() {
  local -a services=(samba filebrowser scrutiny jellyfin qbittorrent)
  local svc

  if [[ -z "$1" ]]; then
    echo "错误：请输入参数，例如: hddm up -d 或 hddm down"
    return 1
  fi

  for svc in $services; do
    dcctl $svc "$@"
  done
}

#######################################
# 硬盘休眠
#######################################

# 打印硬盘状态
hddc() {
  sudo hdparm -C /dev/sd[acd]
}

# 唤醒硬盘
hddw() {
  dcctl_hdd_dep up -d
}

# 硬盘休眠
hdds() {
  local -a disks=(sda sdc sdd)
  local disk

  echo "=== 开始执行硬盘休眠流程 ==="

  # 调用 hddcd 函数关闭所有可能占用硬盘的服务
  echo "正在关闭依赖服务..."
  dcctl_hdd_dep stop

  # 等待 1-2 秒，让系统完全释放文件句柄
  sleep 1

  # 遍历物理休眠所有硬盘
  echo "正在向硬盘发送物理休眠指令 (Spin Down)..."
  for disk in $disks; do
    # -y 参数让机械硬盘立刻停转并进入 standby 模式
    if sudo hdparm -y "/dev/$disk" >/dev/null 2>&1; then
      echo "   -> /dev/$disk 已进入休眠 (Standby)"
    else
      echo "   -> /dev/$disk 休眠失败，请检查权限"
    fi
  done

  echo "=== 流程结束，硬盘已休眠 ==="
}

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
