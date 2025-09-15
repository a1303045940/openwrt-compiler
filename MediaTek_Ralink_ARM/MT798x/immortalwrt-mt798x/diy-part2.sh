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

# # ---------- ubi fix ----------
# # 获取脚本的目录，检查当前工作目录是否为脚本目录
# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# ORIGINAL_DIR="$PWD"
# if [ "$PWD" != "$DIR" ]; then
#     echo "Changing working directory to $DIR"
#     cd "$DIR"
#     echo -e "Current working directory: $(pwd)"
# fi

# # 创建/patches文件夹（如果不存在）
# PATCH_DIR="$DIR/patches"
# if [ ! -d "$PATCH_DIR" ]; then
#     echo "Creating directory $PATCH_DIR"
#     mkdir -p "$PATCH_DIR"
# fi

# # 定义补丁文件的URL和目标路径
# PATCH_URL="https://raw.githubusercontent.com/kiddin9/OpenWrt_x86-r2s-r4s-r5s-N1/master/devices/mediatek_filogic/patches/20-ea0326gmp.patch"
# PATCH_FILE="$PATCH_DIR/20-ea0326gmp.patch"

# # 下载补丁文件到/patches文件夹，并强制覆盖已有文件,检查curl命令是否成功执行
# echo "Downloading patch file to $PATCH_FILE"
# curl -o "$PATCH_FILE" -L "$PATCH_URL"
# if [ $? -eq 0 ]; then
#     echo "Patch file downloaded successfully."
# else
#     echo "Failed to download patch file."
#     exit 1
# fi

# # 获取补丁文件的绝对路径 检查补丁文件是否成功创建
# PATCH_FILE_ABS_PATH="$(realpath "$PATCH_FILE")"
# if [ -f "$PATCH_FILE_ABS_PATH" ]; then
#     echo "Patch file created successfully."
# else
#     echo "Failed to create patch file."
#     exit 1
# fi

# # 切换回原来的工作目录(默认为openwrt根目录)
# echo "Changing back to the original directory $ORIGINAL_DIR"
# cd "$ORIGINAL_DIR"
# if [ $? -eq 0 ]; then
#     echo "Returned to the original directory successfully."
#     echo -e "Current working directory: $(pwd)"
# else
#     echo "Failed to return to the original directory."
#     exit 1
# fi

# # 应用补丁
# echo "Applying patch $PATCH_FILE_ABS_PATH"
# patch -p1 < "$PATCH_FILE_ABS_PATH"
# if [ $? -eq 0 ]; then
#     echo "Patch applied successfully."
# else
#     echo "Failed to apply patch."
#     exit 1
# fi


# # ----- dockerd remove iptables -----
# apply_dockerd_patch_sed() {
#     # 定义目标文件的路径
#     local patch_target="feeds/packages/utils/dockerd/Makefile"
#     patch_target="$(realpath "$patch_target")"

#     # 打印当前目标文件内容
#     echo "Original file content:"
#     cat "$patch_target"

#     # 使用 sed 删除指定行
#     echo "Applying sed commands to remove iptables dependencies..."
#     sed -i '/+iptables \\/d' "$patch_target"
#     sed -i '/+iptables-mod-extra \\/d' "$patch_target"
#     sed -i '/+IPV6:ip6tables \\/d' "$patch_target"
#     sed -i '/+IPV6:kmod-ipt-nat6 \\/d' "$patch_target"
#     sed -i '/+kmod-ipt-nat \\/d' "$patch_target"
#     sed -i '/+kmod-ipt-physdev \\/d' "$patch_target"
#     sed -i '/+kmod-nf-ipvs \\/d' "$patch_target"

#     # 打印修改后的目标文件内容
#     echo "Modified file content:"
#     cat "$patch_target"
# }
# apply_dockerd_patch_sed

# # nftables, abort iptables & xtables
# echo "
# CONFIG_PACKAGE_dnsmasq_full_nftset=y
# CONFIG_DEFAULT_nftables=y
# CONFIG_PACKAGE_miniupnpd-nftables=y
# CONFIG_PACKAGE_nftables-json=y
# CONFIG_PACKAGE_nftables-nojson=n

# CONFIG_PACKAGE_ip6tables-nft=n
# CONFIG_PACKAGE_iptables-mod-extra=n
# CONFIG_PACKAGE_iptables-nft=n
# CONFIG_PACKAGE_iptables-mod-tproxy=n
# CONFIG_PACKAGE_kmod-ip6tables=n

# CONFIG_PACKAGE_libip4tc=n
# CONFIG_PACKAGE_libip6tc=n
# CONFIG_PACKAGE_libiptext=n
# CONFIG_PACKAGE_libiptext-nft=n
# CONFIG_PACKAGE_libiptext6=n

# CONFIG_PACKAGE_libxtables12=n
# CONFIG_PACKAGE_libxtables=n
# CONFIG_PACKAGE_xtables-nft=n

# " >> .config

# # 删除iptables ip6tables
# # ----- opkg whatdepends -----
# # kmod-ipt-core
# # kmod-ipt-conntrack
# # kmod-ipt-nat
# # kmod-ipt-nat6
# # kmod-ipt-extra
# # kmod-ipt-tproxy
# # kmod-ipt-physdev
# # kmod-nf-ipt
# # kmod-nf-ipt6
# # kmod-br-netfilter
# # kmod-ip6tables
# # kmod-ipt-ipset
# # ipset
# # libipset13
# # kmod-nft-compat
# echo "
# CONFIG_PACKAGE_kmod-ipt-core=n
# CONFIG_PACKAGE_kmod-ipt-conntrack=n
# CONFIG_PACKAGE_kmod-ipt-nat=n
# CONFIG_PACKAGE_kmod-ipt-nat-extra=n
# CONFIG_PACKAGE_kmod-ipt-nat6=n
# CONFIG_PACKAGE_kmod-ipt-extra=n
# CONFIG_PACKAGE_kmod-ipt-tproxy=n
# CONFIG_PACKAGE_kmod-ipt-physdev=n
# CONFIG_PACKAGE_kmod-nf-ipt=n
# CONFIG_PACKAGE_kmod-nf-ipt6=n
# CONFIG_PACKAGE_kmod-nf-ipvs=n
# CONFIG_PACKAGE_kmod-br-netfilter=n
# CONFIG_PACKAGE_kmod-ip6tables=n
# CONFIG_PACKAGE_kmod-ip6tables-extra=n
# CONFIG_PACKAGE_ipset=n
# CONFIG_PACKAGE_kmod-ipt-ipset=n
# CONFIG_PACKAGE_libipset=n
# CONFIG_PACKAGE_kmod-nft-compat=n
# " >> .config

# ---------- sync config ----------
make oldconfig
cat ./.config
