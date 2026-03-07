#!/bin/sh

#/root/sys_monitor.sh
# 监控内存、存储和连接数，并在异常时发送邮件通知

# --- 配置区 ---
RECEIVER="liuyuchuan816@live.com"
MEM_THRESHOLD=15    # 内存剩余低于 15% 报警
DISK_THRESHOLD=90   # 存储占用高于 90% 报警
CONN_THRESHOLD=80   # 连接数占用高于 80% 报警

# --- 获取数据 ---
# 1. 内存：提取 Total 和 Available (第 2 列和第 7 列)
MEM_TOTAL=$(free | grep Mem: | awk '{print $2}')
MEM_AVAIL=$(free | grep Mem: | awk '{print $7}')
MEM_FREE_PCT=$(( MEM_AVAIL * 100 / MEM_TOTAL ))

# 2. 存储：提取根目录 (Overlay 分区) 占用率
DISK_USED_PCT=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# 3. 连接数：获取当前连接数与内核上限
if [ -f /proc/sys/net/netfilter/nf_conntrack_count ]; then
    CONN_COUNT=$(cat /proc/sys/net/netfilter/nf_conntrack_count)
    CONN_MAX=$(cat /proc/sys/net/netfilter/nf_conntrack_max)
    CONN_USED_PCT=$(( CONN_COUNT * 100 / CONN_MAX ))
else
    CONN_USED_PCT=0
    CONN_COUNT="N/A"
    CONN_MAX="N/A"
fi

HOSTNAME=$(cat /proc/sys/kernel/hostname)
MODEL=$(cat /tmp/sysinfo/model 2>/dev/null || echo "OpenWrt Device")
UPTIME_STR=$(uptime | awk -F'up ' '{print $2}' | cut -d',' -f1)

MSG=""

# --- 监控逻辑 ---
# 1. 内存检查
if [ "$MEM_FREE_PCT" -lt "$MEM_THRESHOLD" ]; then
    MSG="${MSG}🚨 【内存告警】可用空间仅剩 ${MEM_FREE_PCT}% (低于 ${MEM_THRESHOLD}%)\n"
fi

# 2. 存储检查
if [ "$DISK_USED_PCT" -gt "$DISK_THRESHOLD" ]; then
    MSG="${MSG}🚨 【存储告警】空间占用已达 ${DISK_USED_PCT}% (高于 ${DISK_THRESHOLD}%)\n"
fi

# 3. 连接数检查
if [ "$CONN_USED_PCT" -gt "$CONN_THRESHOLD" ]; then
    MSG="${MSG}🚨 【连接告警】活动连接数异常：${CONN_COUNT}/${CONN_MAX} (${CONN_USED_PCT}%)\n"
fi

# --- 发送邮件 ---
if [ -n "$MSG" ]; then
    (
      echo "To: $RECEIVER"
      echo "Subject: [系统状态] $HOSTNAME 存储/内存/连接异常预警"
      echo "Content-Type: text/plain; charset=UTF-8"
      echo ""
      echo -e "您好，监测到路由器系统状态异常：\n"
      echo -e "--------------------------------------"
      echo -e "$MSG"
      echo -e "--------------------------------------\n"
      echo -e "OpenWrt 管理助手"
      echo -e "设备型号: $MODEL"
      echo -e "运行时间: $UPTIME_STR"
      echo -e "当前连接: $CONN_COUNT / $CONN_MAX"
      echo -e "检测时间: $(date '+%Y-%m-%d %H:%M:%S')"
      echo -e "--------------------------------------"
    ) | msmtp "$RECEIVER"
    
    # 记录到系统日志
    logger -t sys_monitor "已发送资源告警邮件至 $RECEIVER"
fi