#!/bin/zsh

() {
  # --- 配置区域 ---
  local DEFAULT_PROJECT_DIR="/home/tom/nas"
  local NETWORK_NAME="webnet"
  local USE_SUDO=1

  # 根据配置构建前缀数组
  local -a docker_base=(docker compose)
  (( USE_SUDO )) && docker_base=(sudo "${docker_base[@]}")

  # --- 辅助函数 ---

  # 错误处理
  error() { echo "❌ 错误: $1" >&2; return 1 }

  # 检查网络
  ensure_network() {
    if ! sudo docker network inspect "$NETWORK_NAME" &>/dev/null; then
      echo "🌐 创建共享网络: $NETWORK_NAME"
      sudo docker network create "$NETWORK_NAME"
    fi
  }

  # 查找项目
  get_projects() {
    # 使用 Zsh 的修饰符 (:t) 只保留文件名/目录名
    print -l ${DEFAULT_PROJECT_DIR}/*(/N:t)
  }

  # 显示帮助
  show_help() {
    # 1. 定义颜色
    local B=$'\e[1m'  BL=$'\e[34m'  G=$'\e[32m'  Y=$'\e[33m'  NC=$'\e[0m'

    # 2. 头部标题
    echo "\n${B}${BL}Docker Compose 控制工具 (dcctl)${NC}"
    echo "${Y}用法:${NC} dcctl ${G}<项目名>${NC} <命令> [选项]\n"

    # 3. 命令定义 (指令:说明)
    local -a commands=(
      "up:启动项目 (常用: -d)"
      "down:停止并移除容器"
      "restart:重启项目"
      "ps:查看状态"
      "logs:查看日志 (-f)"
      "ls:列出所有可用项目"
      "init:初始化网络 (${NETWORK_NAME})"
    )

    # 4. 循环渲染命令列表 (自动对齐)
    echo "${Y}核心命令:${NC}"
    local cmd desc
    for item in "${commands[@]}"; do
      cmd="${item%%:*}"
      desc="${item#*:}"
      # 使用 printf 保证命令列宽度一致 (10位左对齐)
      printf "  ${G}%-10s${NC} %s\n" "$cmd" "$desc"
    done

    # 5. 底部示例
    echo "\n${Y}示例:${NC}"
    echo "  dcctl ${G}plex${NC} up -d"
    echo "  dcctl ${G}ng${NC} logs -f\n"
  }

  # --- 主逻辑 ---

  # 1. 环境检查
  (( $+commands[docker] )) || { error "Docker 未安装"; return 1 }

  # 2. 处理无参或帮助
  local cmd_arg="$1"
  if [[ -z "$cmd_arg" || "$cmd_arg" == "-h" || "$cmd_arg" == "--help" ]]; then
    show_help
    return 0
  fi

  # 3. 处理全局命令
  case "$cmd_arg" in
    init) ensure_network; return 0 ;;
    ls) echo "📂 可用项目:"; get_projects | sed 's/^/  /'; return 0 ;;
  esac

  # 4. 项目匹配逻辑
  local project_name="$cmd_arg"
  local action="$2"
  shift 2 # 此时 $@ 剩下的是选项如 -d

  if [[ -z "$action" ]]; then
    error "必须指定命令 (up/down/ps...)"
    return 1
  fi

  local -a matches
  # Zsh 强大的数组过滤：查找包含关键字的目录
  local all_projs=($(get_projects))
  matches=(${(M)all_projs:#*$project_name*})

  if (( ${#matches} == 0 )); then
    error "未找到匹配项目 '$project_name'"
    return 1
  elif (( ${#matches} > 1 )); then
    echo "🔍 找到多个匹配:"
    print -l "  "$^matches
    echo "请提供更精确的名称。"
    return 1
  fi

  local final_project="${matches[1]}"
  local project_path="$DEFAULT_PROJECT_DIR/$final_project"

  # 5. 执行前校验
  [[ -f "$project_path/docker-compose.yml" || -f "$project_path/docker-compose.yaml" ]] || \
    { error "$final_project 中未找到 docker-compose 文件"; return 1 }

  [[ "$action" == "up" ]] && ensure_network

  # 6. 执行命令
  echo "🚀 项目: $final_project | 执行: $action $@"
  ( cd "$project_path" && "${docker_base[@]}" $action "$@" )
} "$@"