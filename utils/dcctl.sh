#!/bin/bash
# Docker Compose Control Tool (dcctl)
# 使用方式: dcctl [项目名称] [命令] [选项]
# 支持 sudo 和 docker compose 命令

# 配置区域 - 根据需求修改
DEFAULT_PROJECT_DIR="/home/tom/code/nas/"  # 默认项目根目录
NETWORK_NAME="webnet"              # 共享网络名称
USE_SUDO=1                         # 1=使用sudo, 0=不使用sudo

# 检查 Docker 是否可用
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "错误: Docker 未安装或不在 PATH 中"
        exit 1
    fi
}

# 获取 docker compose 命令前缀
docker_cmd() {
    if [ "$USE_SUDO" -eq 1 ]; then
        echo "sudo docker compose"
    else
        echo "docker compose"
    fi
}

# 检查并创建共享网络
ensure_network() {
    local cmd_prefix
    cmd_prefix=$(docker_cmd)
    
    if ! sudo docker network inspect "$NETWORK_NAME" &> /dev/null; then
        echo "创建共享网络: $NETWORK_NAME"
        sudo docker network create "$NETWORK_NAME"
    fi
}

# 显示帮助信息
show_help() {
    echo "Docker Compose 控制工具 (dcctl)"
    echo "使用方式:"
    echo "  dcctl [项目名称] [命令] [选项]"
    echo ""
    echo "命令:"
    echo "  up       启动项目"
    echo "  down     停止项目"
    echo "  restart  重启项目"
    echo "  ps       查看项目状态"
    echo "  logs     查看项目日志"
    echo "  init     初始化共享网络"
    echo "  list     列出所有项目"
    echo "  pull     拉取最新镜像"
    echo ""
    echo "选项:"
    echo "  -d, --detach  后台运行 (仅适用于 up 命令)"
    echo "  -h, --help    显示帮助信息"
    echo "  -v, --verbose 显示详细输出"
    echo ""
    echo "项目查找:"
    echo "  支持项目名称模糊匹配，输入部分名称即可"
    echo "  例如: 'dcctl nginx up' 或 'dcctl ng up'"
    echo ""
    echo "项目目录: $DEFAULT_PROJECT_DIR"
    echo "共享网络: $NETWORK_NAME"
    echo "使用sudo: $([ "$USE_SUDO" -eq 1 ] && echo "是" || echo "否")"
}

# 查找所有项目目录
find_projects() {
    find "$DEFAULT_PROJECT_DIR" -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | sort
}

# 列出所有项目
list_projects() {
    echo "可用项目:"
    find_projects | while read -r project; do
        echo "  $project"
    done
}

# 查找匹配的项目
find_matching_project() {
    local pattern="$1"
    local matches=()
    
    while IFS= read -r project; do
        if [[ "$project" == *"$pattern"* ]]; then
            matches+=("$project")
        fi
    done < <(find_projects)
    
    echo "${matches[@]}"
}

# 执行命令
run_command() {
    local project_dir="$DEFAULT_PROJECT_DIR/$1"
    local command=$2
    shift 2
    
    if [ ! -d "$project_dir" ]; then
        echo "错误: 项目目录不存在: $project_dir"
        return 1
    fi
    
    if [ ! -f "$project_dir/docker-compose.yml" ]; then
        echo "错误: $project_dir 中未找到 docker-compose.yml"
        return 1
    fi
    
    local cmd_prefix
    cmd_prefix=$(docker_cmd)
    
    echo "执行 [$command] 在项目: $1"
    (cd "$project_dir" && $cmd_prefix "$command" "$@")
}

# 主函数
main() {
    check_docker
    
    # 处理帮助选项
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_help
        exit 0
    fi
    
    # 处理 init 命令
    if [[ "$1" == "init" ]]; then
        ensure_network
        exit 0
    fi
    
    # 处理 list 命令
    if [[ "$1" == "list" ]]; then
        list_projects
        exit 0
    fi
    
    # 必须指定项目名称
    if [ -z "$1" ]; then
        echo "错误: 必须指定项目名称"
        echo "使用 'dcctl list' 查看可用项目"
        show_help
        exit 1
    fi
    
    local project_name="$1"
    shift
    
    # 必须指定命令
    if [ -z "$1" ]; then
        echo "错误: 必须指定命令"
        show_help
        exit 1
    fi
    
    local command="$1"
    shift
    
    # 收集剩余选项
    local options=("$@")
    
    # 检查项目是否存在
    if [ ! -d "$DEFAULT_PROJECT_DIR/$project_name" ]; then
        # 尝试模糊匹配
        local matches
        matches=($(find_matching_project "$project_name"))
        
        if [ ${#matches[@]} -eq 0 ]; then
            echo "错误: 未找到匹配的项目 '$project_name'"
            echo "使用 'dcctl list' 查看可用项目"
            exit 1
        elif [ ${#matches[@]} -eq 1 ]; then
            echo "使用匹配的项目: ${matches[0]}"
            project_name="${matches[0]}"
        else
            echo "找到多个匹配的项目:"
            for match in "${matches[@]}"; do
                echo "  $match"
            done
            echo "请指定更精确的项目名称"
            exit 1
        fi
    fi
    
    # 确保网络存在 (对于 up 命令)
    if [[ "$command" == "up" ]]; then
        ensure_network
    fi
    
    # 执行命令
    run_command "$project_name" "$command" "${options[@]}"
}

main "$@"
