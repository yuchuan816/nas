#!/bin/zsh

# 使用匿名函数包裹，确保 source 执行时也不会污染环境
() {
    local tag desc src dst
    # 配置区：一行就是一个完整的任务，非常易读
    local copy_config=(
        "1" "Movies" "/mnt/common/shares/factory-movies" "/mnt/movies/library"
        "2" "Series" "/mnt/common/shares/factory-series" "/mnt/series/library"
    )

    # 1. 构造菜单（Zsh 的数组处理非常强大，直接切片拼接）
    local menu_args=()
    for tag desc src dst in "${copy_config[@]}"; do
        menu_args+=("$tag" "$desc")
    done

    # 2. 弹出菜单
    local OPTION=$(whiptail --title "媒体导入工具" --menu "请选择要导入的类型：" 12 45 2 \
        "${menu_args[@]}" 3>&1 1>&2 2>&3)

    # 检查取消操作
    [[ $? != 0 ]] && return 0

    # 3. 匹配并执行
    for tag desc src dst in "${copy_config[@]}"; do
        if [[ "$tag" == "$OPTION" ]]; then
            echo "📂 正在导入 $desc (已过滤隐藏文件)..."
            mkdir -p "$dst"
            
            # 核心修改点
            rsync -ah --preallocate --info=progress2 --exclude=".*" "$src/" "$dst/"
            
            echo "✅ $desc 导入完成！"
            break
        fi
    done
}