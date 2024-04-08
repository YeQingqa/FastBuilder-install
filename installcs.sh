#!/bin/bash

# 获取处理器架构
get_architecture() {
    architecture=$(uname -m)
    echo "$architecture"
}

# 获取处理器型号（仅在 x86 架构下）
get_processor() {
    if [ "$(get_architecture)" == "x86_64" ]; then
        processor=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ':' -f 2 | xargs)
        echo "$processor"
    else
        echo "N/A"
    fi
}

# 获取系统内存
get_memory() {
    if [ -f "/proc/meminfo" ]; then
        memory=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
        memory_in_GB=$(echo "scale=1; $memory / (1000^2)" | bc)
        echo "$memory_in_GB"
    else
        echo "N/A"
    fi
}

# 获取系统版本
get_os_version() {
    if [ -f /etc/os-release ]; then
        version=$(grep "PRETTY_NAME" /etc/os-release | cut -d '=' -f 2 | tr -d '"' )
        if [ -z "$version" ]; then
            version="Unknown"
        fi
    elif [ -f /etc/redhat-release ]; then
        version=$(cat /etc/redhat-release)
    elif [ -f /etc/lsb-release ]; then
        version=$(grep "DESCRIPTION" /etc/lsb-release | cut -d '=' -f 2 | tr -d '"' )
    else
        version="Unknown"
    fi
    echo "$version"
}

# 检查是否为 root 用户
check_root() {
    if [ $(id -u) -eq 0 ]; then
        echo "是"
    else
        echo "否"
    fi
}

# 检查 FastBuilder 服务状态
check_fastbuilder_status() {
    local status=$(curl -s -o /dev/null -w "%{http_code}" api.fastbuilder.pro)
    local delay=$(ping -c 10 -i 0.2 -w 2 api.fastbuilder.pro | grep -oP 'time=\K[^ ]+' | cut -d '.' -f 1 | sort -n | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        echo -e "F B 验证服务状态: 正常 - ${delay}ms"
    elif [ "$status" -eq 000 ]; then
        echo -e "F B 验证服务状态: 异常 - N/A"
    else
        echo -e "F B 验证服务状态: 异常 - N/A"
    fi
}

# 检查咕咕验证服务状态
check_googoostatus() {
    local status=$(curl -s -o /dev/null -w "%{http_code}" https://liliya233.uk/)
    local delay=$(ping -c 10 -i 0.2 -w 2 liliya233.uk | grep -oP 'time=\K[^ ]+' | cut -d '.' -f 1 | sort -n | tail -n 1)
    
    if [ "$status" -eq 200 ]; then
        echo -e "咕咕验证服务状态: 正常 - ${delay}ms"
    elif [ "$status" -eq 000 ]; then
        echo -e "咕咕验证服务状态: 异常 - N/A"
    else
        echo -e "咕咕验证服务状态: 异常 - N/A"
    fi
}

# 安装 bc
install_bc() {
    echo "正在安装 bc ..."
    if [ "$(command -v apt-get)" ]; then
        apt-get update
        apt-get install -y bc
    elif [ "$(command -v yum)" ]; then
        yum install -y bc
    else
        echo "无法确定系统包管理器"
        exit 1
    fi
}

# 安装 Neomega
install_neomega() {
    echo "正在安装 Neomega ..."
    bash -c "$(curl -fsSL https://omega-1259160345.cos.ap-nanjing.myqcloud.com/fastbuilder_launcher/install.sh)"
}

# 安装 FastBuilder
install_fastbuilder() {
    echo "正在安装 FastBuilder ..."
    export PB_USE_GH_REPO=1 && export GH_DOMAIN="https://github.moeyy.xyz/https://github.com/" && bash -c "$(curl -fsSL https://download.yeqingg.cn/fastbuilder/install.sh)"
}

# 安装 FastBuilder-Libre
install_fastbuilder_libre() {
    echo "正在安装 FastBuilder-Libre ..."
    export PB_USE_GH_REPO=1 && export GH_DOMAIN="https://github.moeyy.xyz/https://github.com/" && bash -c "$(curl -fsSL https://download.yeqingg.cn/fastbuilderlibre/install.sh)"
}

# 主函数
main() {
    # 检查并安装 bc
    if ! command -v bc &>/dev/null; then
        install_bc
    fi

    # 安装 Neomega
    install_neomega

    # 安装 FastBuilder
    install_fast
