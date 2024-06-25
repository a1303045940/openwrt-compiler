#!/bin/bash

# Old Luci
echo "
CONFIG_PACKAGE_luci-compat=y
" >> .config

# Add luci-app-adguardhome
rm -rf package/luci-app-adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/luci-app-adguardhome
echo "
CONFIG_PACKAGE_luci-app-adguardhome=y
" >> .config

# https-dns-proxy
echo "
CONFIG_PACKAGE_luci-app-https-dns-proxy=y
CONFIG_PACKAGE_https-dns-proxy=y
" >> .config

# udpxy
echo "
CONFIG_PACKAGE_luci-app-udpxy=y
CONFIG_PACKAGE_udpxy=y
" >> .config

# squid
echo "
CONFIG_PACKAGE_luci-app-squid=y
CONFIG_PACKAGE_squid=y
" >> .config

# iperf3
echo "
CONFIG_PACKAGE_iperf=n
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_iperf3-ssl=n
" >> .config

# batman-adv
# echo "
# CONFIG_PACKAGE_luci-proto-batman-adv=y
# CONFIG_PACKAGE_kmod-batman-adv=y
# CONFIG_PACKAGE_batctl-default=n
# CONFIG_PACKAGE_batctl-full=y
# CONFIG_PACKAGE_batctl-tiny=n
# " >> .config

echo "
# Docker
CONFIG_PACKAGE_docker=y
CONFIG_PACKAGE_docker-compose=y
CONFIG_PACKAGE_dockerd=y
# Docker Luci
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y
CONFIG_PACKAGE_luci-lib-docker=y
# Docker etc
CONFIG_PACKAGE_libcgroup=y
" >> .config

# ---------- sync config ----------
make oldconfig
cat ./.config
