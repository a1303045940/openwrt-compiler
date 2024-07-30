#!/bin/bash

# # Old Luci
# echo "
# CONFIG_PACKAGE_luci-compat=y
# " >> .config

# # Add luci-app-adguardhome
# rm -rf package/luci-app-adguardhome
# git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/luci-app-adguardhome
# echo "
# CONFIG_PACKAGE_luci-app-adguardhome=y
# " >> .config

# # https-dns-proxy
# echo "
# CONFIG_PACKAGE_luci-app-https-dns-proxy=y
# CONFIG_PACKAGE_https-dns-proxy=y
# " >> .config

# # udpxy
# echo "
# CONFIG_PACKAGE_luci-app-udpxy=y
# CONFIG_PACKAGE_udpxy=y
# " >> .config

# # squid
# echo "
# CONFIG_PACKAGE_luci-app-squid=y
# CONFIG_PACKAGE_squid=y
# " >> .config

# # iperf3
# echo "
# CONFIG_PACKAGE_iperf=n
# CONFIG_PACKAGE_iperf3=y
# CONFIG_PACKAGE_iperf3-ssl=n
# " >> .config

# # batman-adv
# echo "
# CONFIG_PACKAGE_luci-proto-batman-adv=y
# CONFIG_PACKAGE_kmod-batman-adv=y
# CONFIG_PACKAGE_batctl-default=n
# CONFIG_PACKAGE_batctl-full=y
# CONFIG_PACKAGE_batctl-tiny=n
# " >> .config

# ---------- ubi fix ----------
# 获取脚本的目录，检查当前工作目录是否为脚本目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ORIGINAL_DIR="$PWD"
if [ "$PWD" != "$DIR" ]; then
    echo "Changing working directory to $DIR"
    cd "$DIR"
    echo -e "Current working directory: $(pwd)"
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

# 下载补丁文件到/patches文件夹，并强制覆盖已有文件,检查curl命令是否成功执行
echo "Downloading patch file to $PATCH_FILE"
curl -o "$PATCH_FILE" -L "$PATCH_URL"
if [ $? -eq 0 ]; then
    echo "Patch file downloaded successfully."
else
    echo "Failed to download patch file."
    exit 1
fi

# 获取补丁文件的绝对路径 检查补丁文件是否成功创建
PATCH_FILE_ABS_PATH="$(realpath "$PATCH_FILE")"
if [ -f "$PATCH_FILE_ABS_PATH" ]; then
    echo "Patch file created successfully."
else
    echo "Failed to create patch file."
    exit 1
fi

# 切换回原来的工作目录
echo "Changing back to the original directory $ORIGINAL_DIR"
cd "$ORIGINAL_DIR"
if [ $? -eq 0 ]; then
    echo "Returned to the original directory successfully."
    echo -e "Current working directory: $(pwd)"
else
    echo "Failed to return to the original directory."
    exit 1
fi

# 应用补丁
echo "Applying patch $PATCH_FILE_ABS_PATH"
patch -p1 < "$PATCH_FILE_ABS_PATH"
if [ $? -eq 0 ]; then
    echo "Patch applied successfully."
else
    echo "Failed to apply patch."
    exit 1
fi

# ---------- sync config ----------
make oldconfig
cat ./.config
