#!/bin/bash

# 获取脚本的目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查当前工作目录是否为脚本目录
if [ "$PWD" != "$DIR" ]; then
    echo "Changing working directory to $DIR"
    cd "$DIR"
fi

# 创建/patches文件夹（如果不存在）
PATCH_DIR="$DIR/patches"
if [ ! -d "$PATCH_DIR" ]; then
    echo "Creating directory $PATCH_DIR"
    mkdir -p "$PATCH_DIR"
fi

# 定义补丁文件的URL和目标路径
PATCH_URL="https://raw.githubusercontent.com/kiddin9/OpenWrt_x86-r2s-r4s-r5s-N1/master/devices/mediatek_filogic/patches/20-ea0326gmp.patch"
PATCH_FILE="$PATCH_DIR/20-ea0326gmp.patch"

# 下载补丁文件到/patches文件夹，并强制覆盖已有文件
echo "Downloading patch file to $PATCH_FILE"
curl -o "$PATCH_FILE" -L "$PATCH_URL"

# 检查curl命令是否成功
if [ $? -eq 0 ]; then
    echo "Patch file downloaded successfully."
else
    echo "Failed to download patch file."
    exit 1
fi
