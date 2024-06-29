#!/bin/bash


# https-dns-proxy
echo "
CONFIG_PACKAGE_luci-app-https-dns-proxy=y
CONFIG_PACKAGE_https-dns-proxy=y
" >> .config

# ---------- sync config ----------
make oldconfig
cat ./.config
