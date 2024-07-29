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

# ---------- sync config ----------
make oldconfig
cat ./.config
