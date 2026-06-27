#!/usr/bin/env zsh

# ==============================================================================
# 脚本名: hdd-sleep-monitor.zsh
# 作用: 基于 ZSH 语法，监控 sda, sdc, sdd 的休眠状态并记录到指定日志
# ==============================================================================

monitor_main() {
  # 严格定义局部变量
  local -a disks=(sda sdc sdd)
  local log_dir="/home/tom/nas/backup/logs"
  local log_file="$log_dir/hdd_status.log"
  local disk disk_status timestamp

  # 权限预检：检查是否有 root 权限（hdparm 必须）
  if [[ $EUID -ne 0 ]]; then
    echo "错误：该脚本需要 root 权限来读取硬盘状态。"
    echo "请使用 'sudo ./hdd-sleep-monitor.zsh' 运行，或者将其配置为 Systemd 服务。"
    return 1
  fi

  # 创建日志目录
  [[ -d $log_dir ]] || mkdir -p $log_dir

  echo "==== ZSH 硬盘休眠监控已启动 ($(date)) ====" >> $log_file

  # 主循环
  while true; do
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    for disk in $disks; do
      # 获取状态并清洗字符串
      disk_status=$(hdparm -C "/dev/$disk" 2>/dev/null | grep "drive state" | cut -d: -f2 | xargs)

      # 容错：防止获取失败导致日志错位
      [[ -z $disk_status ]] && disk_status="unknown/error"

      # 写入日志
      echo "[$timestamp] $disk: $disk_status" >> $log_file
    done

    # 每一轮检查后打一个空行，增强日志可读性
    echo "" >> $log_file

    # 每 5 分钟（300秒）轮询一次
    sleep 300
  done
}

# 执行入口函数
monitor_main