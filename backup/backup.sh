#!/bin/bash

# 每天15点执行
# 0 3 * * * /home/tom/code/nas/backup/backup.sh

# 配置变量，使用绝对路径
BACKUP_DIR="/home/tom/code/nas/backup"

SOURCE_MOVIES="/mnt/movies/library"
SOURCE_SERIES="/mnt/series/library"
SOURCE_ART="/mnt/common/shares/.art/video"

OMZ_CONFIG="/home/tom/.oh-my-zsh/custom/plugins/my-custom-commands/my-custom-commands.plugin.zsh"

# 执行备份，并输出日志
{
    echo "开始备份: $(date)"
    /usr/bin/ls "$SOURCE_MOVIES" > "$BACKUP_DIR/movies.txt"
    /usr/bin/ls "$SOURCE_SERIES" > "$BACKUP_DIR/series.txt"
    /usr/bin/ls "$SOURCE_ART" > "$BACKUP_DIR/art.txt"
    /bin/cp "$OMZ_CONFIG" "$BACKUP_DIR/my-custom-commands.plugin.zsh"
    echo "备份完成: $(date)"
} >> "$BACKUP_DIR/logs/backup.log" 2>&1 # 将标准输出和错误都重定向到日志文件