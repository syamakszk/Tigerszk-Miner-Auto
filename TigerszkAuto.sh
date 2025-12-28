#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
if ! grep -q "$WATERMARK_NAME" "$0"; then
    echo -e "\e[1;31m[WARNING] Script watermark has been modified!\e[0m"
    echo -e "\e[1;31mUnauthorized copy detected.\e[0m"
    sleep 3
fi

echo -e "\e[1;33m--[AUTO VERUS MINING ANDROID 5, 6, 7+, 32 & 64 Bit]--\e[0m"
sleep 2
echo -e "\e[1;33m[INFO] Starting Auto Installation\e[0m"
echo -e "\e[1;33mMake sure Termux stays open until installation is complete\e[0m"
sleep 2

echo ""
echo -e "\e[1;33m[SCAN] Detecting device before installing ccminer.\e[0m"
sleep 2

BRAND=$(getprop ro.product.brand)
DEVICE_NAME=$(getprop ro.product.model)
DEVICE_CODE=$(getprop ro.product.device)
CPU_PART=$(grep -m1 'CPU part' /proc/cpuinfo | awk '{print $4}')
ARCH=$(uname -m)
OS_BITS=$(getprop ro.product.cpu.abi | grep -q '64' && echo "64-bit" || echo "32-bit")
ANDROID_VER=$(getprop ro.build.version.release | cut -d'.' -f1)
CHIPSET=$(getprop ro.board.platform)

if [ -d /sys/devices/system/cpu ]; then
    CPU_CORES=$(ls -d /sys/devices/system/cpu/cpu[0-9]* 2>/dev/null | wc -l)
else
    CPU_CORES=$(grep -c '^processor' /proc/cpuinfo)
fi

RAM_MB=$(grep -m1 'MemTotal' /proc/meminfo | awk '{print int($2/1024)}')

if   [ $RAM_MB -le 768 ]; then
  RAM_GB="0.5"
elif [ $RAM_MB -le 1536 ]; then
  RAM_GB=1
elif [ $RAM_MB -le 2560 ]; then
  RAM_GB=2
elif [ $RAM_MB -le 3072 ]; then
  RAM_GB=3
elif [ $RAM_MB -le 4096 ]; then
  RAM_GB=4
elif [ $RAM_MB -le 6144 ]; then
  RAM_GB=6
elif [ $RAM_MB -le 8192 ]; then
  RAM_GB=8
elif [ $RAM_MB -le 12288 ]; then
  RAM_GB=12
elif [ $RAM_MB -le 16384 ]; then
  RAM_GB=16
elif [ $RAM_MB -le 32768 ]; then
  RAM_GB=32
elif [ $RAM_MB -le 65536 ]; then
  RAM_GB=64
elif [ $RAM_MB -le 131072 ]; then
  RAM_GB=128
else
  RAM_GB=$(echo "($RAM_MB/1024+0.5)/1" | bc)
fi

LINE="=============================================="
echo -e "\e[1;34m$LINE\e[0m"
echo -e "Brand           : \e[1;32m$BRAND\e[0m"
echo -e "Device          : \e[1;32m$DEVICE_NAME / $DEVICE_CODE\e[0m"
echo -e "Chipset         : \e[1;32m$CHIPSET\e[0m"
echo -e "Architecture    : \e[1;32m$ARCH\e[0m"
echo -e "CPU Part        : \e[1;32m$CPU_PART\e[0m"
echo -e "CPU Cores       : \e[1;32m$CPU_CORES\e[0m"
echo -e "Total RAM       : \e[1;32m$RAM_GB GB\e[0m"
echo -e "OS Architecture : \e[1;32m$OS_BITS\e[0m"
echo -e "Android Version : \e[1;32m$ANDROID_VER\e[0m"
echo -e "\e[1;34m$LINE\e[0m"
echo ""
sleep 2

msg1="\e[1;33mscript by \e[36mTig\e[31mers\e[37mzk\e[0m"
msg2="\e[1;33mPlease like, share and subscribe to my channel\e[0m"

for i in {1..5}; do
  echo -ne "\r$msg1 $(printf ' %.0s.' $(seq 1 $i))"
  sleep 1
done
echo -e "\n"

for i in {1..5}; do
  echo -ne "\r$msg2 $(printf ' %.0s.' $(seq 1 $i))"
  sleep 1
done
echo -e "\n"

pkg update -y && yes | pkg upgrade -y
pkg install clang make automake autoconf libtool pkg-config binutils build-essential -y
pkg install libcurl openssl-tool libjansson -y
pkg install wget git nano termux-api curl tar unzip file -y

if [ "$OS_BITS" = "32-bit" ]; then
    echo -e "\e[1;33m[INFO] 32-bit device detected, installing patched ccminer, please wait\e[0m"
    sleep 5
else
    echo -e "\e[1;33m[INFO] 64-bit device detected, installing ccminer, please wait\e[0m"
    sleep 5
fi

echo ""
echo -e "\e[1;32mINSTALLATION COMPLETED\e[0m"
echo "Edit pool, wallet, and CPU threads according to your device before mining."
echo -e "\e[1;97mType \e[1;92msetting \e[1;97mor \e[1;92mnano ~/ccminer/start.sh \e[1;97mto edit\e[0m"
echo -e "\e[1;97mType \e[1;92mspek \e[1;97mto view device specifications\e[0m"
echo "Type exit in Termux and reopen it to start mining"
echo "To stop mining, press CTRL + C"
echo "[IMPORTANT] Before restarting the device, enable auto-start for Termux and Termux Boot, grant all permissions, and disable battery optimization"
echo ""
