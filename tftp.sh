### cat /proc/mtd
# dev:    size   erasesize  name
# mtd0: 00100000 00020000 "bl2"
# mtd1: 00080000 00020000 "u-boot-env"
# mtd2: 00200000 00020000 "factory"
# mtd3: 00200000 00020000 "fip"
# mtd4: 00200000 00020000 "config"
# mtd5: 00200000 00020000 "config2"
# mtd6: 06e00000 00020000 "ubi"

# root@ImmortalWrt:~# cat /proc/mtd
# dev:    size   erasesize  name
# mtd0: 08000000 00020000 "spi0.0"
# mtd1: 00100000 00020000 "BL2"
# mtd2: 00080000 00020000 "u-boot-env"
# mtd3: 00200000 00020000 "Factory"
# mtd4: 00200000 00020000 "FIP"
# mtd5: 00200000 00020000 "Config"
# mtd6: 00200000 00020000 "Config2"
# mtd7: 06e00000 00020000 "ubi"

/home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-squashfs-sysupgrade.itb
/home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-initramfs-recovery.itb
/home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-preloader.bin
/home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-bl31-uboot.fip


# 登录路由器
ssh-keygen -f '/home/user/.ssh/known_hosts' -R '192.168.1.1'
ssh root@192.168.1.1

# cat /home/user/github/openwrt-settings/openwrt/ea0326gmp/NCPD.sh | ssh root@192.168.1.1 "cat > /tmp/NCPD.sh"


# 登录路由器备份分区
ssh root@192.168.1.1 "dd if=/dev/mtd0 of=/tmp/mtd0_bl2.bin && dd if=/dev/mtd3 of=/tmp/mtd3_fip.bin && dd if=/dev/mtd2 of=/tmp/mtd2_factory.bin"
# 从路由器下载备份到本地
scp root@192.168.1.1:/tmp/mtd0_bl2.bin ./
scp root@192.168.1.1:/tmp/mtd3_fip.bin ./
scp root@192.168.1.1:/tmp/mtd2_factory.bin ./

# 传输preloader.bin
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-preloader.bin | ssh root@192.168.1.1 "cat > /tmp/preloader.bin"
# 传输bl31-uboot.fip
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-bl31-uboot.fip | ssh root@192.168.1.1 "cat > /tmp/bl31-uboot.fip"
# 传输initramfs-recovery.itb（可选）
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-initramfs-recovery.itb | ssh root@192.168.1.1 "cat > /tmp/initramfs-recovery.itb"
# 传输sysupgrade.itb
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-squashfs-sysupgrade.itb | ssh root@192.168.1.1 "cat > /tmp/sysupgrade.itb"


# 登录路由器
ssh-keygen -f '/home/user/.ssh/known_hosts' -R '192.168.1.1'
ssh root@192.168.1.1

# 以下命令在路由器上执行
# 加载kmod-mtd-rw模块
insmod /lib/modules/$(uname -r)/mtd-rw.ko i_want_a_brick=1

# 验证并刷写preloader到BL2分区
md5sum /tmp/preloader.bin
mtd erase BL2
mtd write /tmp/preloader.bin BL2
mtd verify /tmp/preloader.bin BL2

# 验证并刷写bl31-uboot.fip到FIP分区
md5sum /tmp/bl31-uboot.fip
mtd erase FIP
mtd write /tmp/bl31-uboot.fip FIP
mtd verify /tmp/bl31-uboot.fip FIP

# 清除pstore防止启动到恢复模式
rm -f /sys/fs/pstore/*


# 以下命令在路由器上执行
# 更新系统（不保留配置）
sysupgrade -n /tmp/sysupgrade.itb


### tftp恢复
# 更新软件包列表
sudo apt update
# 安装tftpd-hpa服务器
sudo apt install -y tftpd-hpa

# 创建TFTP目录
mkdir -p /srv/tftp
chmod 777 /srv/tftp
# 编辑TFTP配置文件
sudo nano /etc/default/tftpd-hpa
# 将配置文件内容修改为：
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/srv/tftp"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure"
# 重启TFTP服务
sudo systemctl restart tftpd-hpa
# 确认服务运行状态
sudo systemctl status tftpd-hpa

# 临时配置网络接口为192.168.1.254
sudo ip addr add 192.168.1.254/24 dev eth0
# 确认IP配置成功
ip addr show eth0


# 复制recovery.itb文件到TFTP目录
cp /path/to/your/initramfs-recovery.itb /srv/tftp/

# 重命名为路由器所需的文件名
# 对于红米AX6000：
cp /srv/tftp/initramfs-recovery.itb /srv/tftp/openwrt-mediatek-filogic-xiaomi_redmi-router-ax6000-ubootmod-initramfs-recovery.itb
# 对于Nokia EA0326GMP：
cp /srv/tftp/initramfs-recovery.itb /srv/tftp/openwrt-mediatek-filogic-nokia_ea0326gmp-ubootmod-initramfs-recovery.itb

# 设置正确的权限
chmod 644 /srv/tftp/*

# 监控TFTP传输日志 在一个单独的终端窗口中运行：
sudo journalctl -f -u tftpd-hpa


# 6. 触发路由器进入TFTP恢复模式
# 连接网线：将网线连接到路由器的LAN口和电脑
# 断开路由器电源
# 按住路由器RESET按钮
# 接通路由器电源
# 继续按住RESET按钮约5秒
# 释放RESET按钮
# 此时路由器应进入TFTP恢复模式，尝试从您的电脑下载恢复镜像。

# 7. 排查问题
# 如果遇到传输问题：
# 1.ubootmod的使用
# 根据ubootmod的env环境变量：
# ipaddr=192.168.1.1
# serverip=192.168.1.254
# bootfile=openwrt-mediatek-filogic-xiaomi_redmi-router-ax6000-ubootmod-initramfs-recovery.itb
# 我们可以看到ubootmod启动后，TFTP（路由器）IP是192.168.1.1，TFTP服务器（电脑）IP是192.168.1.254。
# 上传文件名是openwrt-mediatek-filogic-xiaomi_redmi-router-ax6000-ubootmod-initramfs-recovery.itb

### 请在tftp文件夹中放置精确的文件名例如openwrt-mediatek-filogic-nokia_ea0326gmp-initramfs-recovery.itb
### chmod 777 /srv/tftp


# 停止当前运行的tftpd-hpa服务
sudo systemctl stop tftpd-hpa
# 禁用服务开机自启动
sudo systemctl disable tftpd-hpa
# 确认服务已停止并禁用
sudo systemctl status tftpd-hpa



### ea0326gmp raw

ssh-keygen -f '/home/user/.ssh/known_hosts' -R '192.168.10.1'
ssh root@192.168.10.1

# 上传 u-boot 写入
# scp /home/user/下载/openwrt/uboot/mt7981_nokia_ea0326gmp-fip-fixed-parts.bin root@192.168.10.1:/tmp

cat /home/user/下载/openwrt/uboot/mt7981_nokia_ea0326gmp-fip-fixed-parts.bin | ssh root@192.168.10.1 "cat > /tmp/mt7981_nokia_ea0326gmp-fip-fixed-parts.bin"
ssh root@192.168.10.1 "ls -lh /tmp/mt7981_nokia_ea0326gmp-fip-fixed-parts.bin"
# mtd write /tmp/mt7981_nokia_ea0326gmp-fip-fixed-parts.bin FIP
ssh root@192.168.10.1 "mtd write /tmp/mt7981_nokia_ea0326gmp-fip-fixed-parts.bin FIP"

ssh root@192.168.10.1 "reboot"






# root@cmcc:~# cat /proc/mtd
# dev:    size   erasesize  name
# mtd0: 08000000 00020000 "spi0.0"
# mtd1: 00100000 00020000 "BL2"
# mtd2: 00080000 00020000 "u-boot-env"
# mtd3: 00200000 00020000 "Factory"
# mtd4: 00200000 00020000 "FIP"
# mtd5: 00200000 00020000 "Config"
# mtd6: 00200000 00020000 "Config2"
# mtd7: 00c00000 00020000 "Aos-net"
# mtd8: 00c00000 00020000 "bvasPlugin"
# mtd9: 05680000 00020000 "ubi"


# 传输preloader.bin
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-preloader.bin | ssh root@192.168.1.1 "cat > /tmp/preloader.bin"
# 传输bl31-uboot.fip
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-bl31-uboot.fip | ssh root@192.168.1.1 "cat > /tmp/bl31-uboot.fip"
# 传输initramfs-recovery.itb（可选）
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-initramfs-recovery.itb | ssh root@192.168.1.1 "cat > /tmp/initramfs-recovery.itb"
# 传输sysupgrade.itb
cat /home/user/下载/openwrt/official/openwrt-mediatek-filogic-nokia_ea0326gmp-squashfs-sysupgrade.itb | ssh root@192.168.1.1 "cat > /tmp/sysupgrade.itb"



# 登录路由器
ssh-keygen -f '/home/user/.ssh/known_hosts' -R '192.168.1.1'
ssh root@192.168.1.1

# 以下命令在路由器上执行
# 加载kmod-mtd-rw模块
insmod /lib/modules/$(uname -r)/mtd-rw.ko i_want_a_brick=1

# 验证并刷写preloader到BL2分区
md5sum /tmp/preloader.bin
mtd erase BL2
mtd write /tmp/preloader.bin BL2
mtd verify /tmp/preloader.bin BL2

# 验证并刷写bl31-uboot.fip到FIP分区
md5sum /tmp/bl31-uboot.fip
mtd erase FIP
mtd write /tmp/bl31-uboot.fip FIP
mtd verify /tmp/bl31-uboot.fip FIP

# 清除pstore防止启动到恢复模式
rm -f /sys/fs/pstore/*

# 更新系统（不保留配置）
sysupgrade -n /tmp/sysupgrade.itb
reboot

# 重启TFTP服务
sudo systemctl restart tftpd-hpa
# 确认服务运行状态
sudo systemctl status tftpd-hpa

# 停止当前运行的tftpd-hpa服务
sudo systemctl stop tftpd-hpa
# 禁用服务开机自启动
sudo systemctl disable tftpd-hpa
# 确认服务已停止并禁用
sudo systemctl status tftpd-hpa
