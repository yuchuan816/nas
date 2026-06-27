#!/bin/zsh

() {
  # 使用 local 声明局部变量
  local BACKUP_DIR="/home/tom/nas/backup"
  local LOG_FILE="$BACKUP_DIR/logs/backup.log"

  # 局部关联数组
  local -A backup_tasks
  backup_tasks=(
    "$BACKUP_DIR/movies.txt" "/mnt/movies/library"
    "$BACKUP_DIR/series.txt" "/mnt/series/library"
    "$BACKUP_DIR/art.txt"    "/mnt/common/shares/.art/video"
  )

  # 确保目录存在
  mkdir -p "$BACKUP_DIR/logs"

  {
    echo "--- 备份开始: $(date '+%Y-%m-%d %H:%M:%S') ---"

    # 使用 local 定义循环变量
    local target source
    for target source in ${(kv)backup_tasks}; do
      if [[ -d "$source" ]]; then
        print -l $source/*(N:t) > "$target"
        echo "[成功] 已记录列表: $source"
      else
        echo "[跳过] 目录未挂载: $source"
      fi
    done

    echo "--- 备份完成 ---"
    echo ""
  } >> "$LOG_FILE" 2>&1
}