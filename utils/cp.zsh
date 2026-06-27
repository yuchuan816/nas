#!/bin/zsh

() {
  echo "📂 媒体自动导入工具"
  echo "-----------------------------------"

  # 选项列表
  local options=("Movies-🎬" "Series-📺" "退出 ❌")
  local PROMPT="👉 请选择要导入的类型 (输入数字并回车): "
  local PS3=$'\n'"$PROMPT"

  local opt
  select opt in "${options[@]}"; do
    local src=""
    local dst=""

    case "$opt" in
      "退出 ❌")
        echo "\n👋 已取消操作。"
        return 0
        ;;
      "Movies-🎬")
        src="/mnt/common/shares/factory-movies"
        dst="/mnt/movies/library"
        ;;
      "Series-📺")
        src="/mnt/common/shares/factory-series"
        dst="/mnt/series/library"
        ;;
      *)
        echo "\n❌ 输入错误，请输入有效的数字（1-3）。"
        continue
        ;;
    esac

    # 防止变量空值或误触根目录
    if [[ -z "$src" || -z "$dst" || "$src" == "/" || "$dst" == "/" ]]; then
      echo "\n❌ [危险保护] 检测到非法路径！src: '$src', dst: '$dst'。脚本拒绝执行。"
      return 1
    fi

    # 安全通过，开始执行
    echo "\n📂 正在导入 $opt (已过滤隐藏文件)..."
    echo "   源路径: $src/"
    echo "   目标路径: $dst/"

    mkdir -p "$dst"
    rsync -ah --preallocate --info=progress2 --exclude=".*" "$src/" "$dst/"

    echo "✅ $opt 导入完成！"
    break
  done
}