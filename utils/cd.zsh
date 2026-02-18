#!/bin/zsh

() {
    local tag desc target_path
    local menu_config=(
        "1" "Movies" "/mnt/movies/library"
        "2" "Series" "/mnt/series/library"
        "3" "Shares" "/mnt/common/shares"
    )

    local menu_args=()
    for tag desc target_path in "${menu_config[@]}"; do
        menu_args+=("$tag" "$desc")
    done

    local OPTION=$(whiptail --title "NAS 快速跳转" --menu "请选择目标目录：" 15 45 5 \
        "${menu_args[@]}" 3>&1 1>&2 2>&3)

    [[ $? != 0 ]] && return 0

    for tag desc target_path in "${menu_config[@]}"; do
        if [[ "$tag" == "$OPTION" ]]; then
            if [[ -d "$target_path" ]]; then
                # 我们需要改变父 Shell 的目录，所以这里直接 cd
                cd "$target_path"
                echo "🚀 已进入: $target_path"
            else
                echo "❌ 错误: 目录不存在 ($target_path)"
            fi
            break
        fi
    done
}