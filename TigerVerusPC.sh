#!/usr/bin/env bash
set -e

# ============================================================
# AUTHOR      : Tigerszk
# PROJECT     : Verus Auto Mining Ubuntu
# WATERMARK   : TIGERSZK-VM-9F3A2C7E
# ============================================================

if ! grep -q "Tigerszk" "$0"; then
    echo "[WARNING] Script watermark modified!"
    sleep 3
fi

echo "=== VERUS AUTO MINER UBUNTU ==="
sleep 1

# Detect CPU vendor
CPU_VENDOR=$(lscpu | grep "Vendor ID" | awk '{print $3}')
CPU_CORES=$(nproc)
ARCH=$(uname -m)

echo "CPU Vendor : $CPU_VENDOR"
echo "CPU Cores  : $CPU_CORES"
echo "Arch       : $ARCH"
sleep 2

# ------------------------------------------------------------
# System update & dependencies
# ------------------------------------------------------------
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y \
build-essential automake autoconf libtool pkg-config \
libcurl4-openssl-dev libssl-dev libjansson-dev \
clang git cmake wget curl nano screen

# ------------------------------------------------------------
# Build ccminer (VerusHash optimized fork)
# ------------------------------------------------------------
cd ~
if [ ! -d ccminer ]; then
    git clone https://github.com/monkins1010/ccminer.git
fi

cd ccminer
git pull

# CPU optimizations
CFLAGS="-O3 -march=native -mtune=native"

if [[ "$CPU_VENDOR" == "AuthenticAMD" ]]; then
    echo "[INFO] AMD CPU detected – enabling Zen optimizations"
    CFLAGS="$CFLAGS -mavx2 -mfma"
elif [[ "$CPU_VENDOR" == "GenuineIntel" ]]; then
    echo "[INFO] Intel CPU detected – enabling AVX optimizations"
    CFLAGS="$CFLAGS -mavx2 -mfma"
fi

./autogen.sh
CFLAGS="$CFLAGS" ./configure
make -j"$CPU_CORES"

# ------------------------------------------------------------
# Create mining start script
# ------------------------------------------------------------
cat > ~/ccminer/start.sh <<'EOF'
#!/usr/bin/env bash

POOL=stratum+tcp://na.luckpool.net:3956
WALLET=YOUR_VERUS_WALLET_ADDRESS
WORKER=ubuntu-rig
THREADS=$(nproc)

cd ~/ccminer
./ccminer -a verus \
-o $POOL \
-u ${WALLET}.${WORKER} \
-p x \
-t $THREADS
EOF

chmod +x ~/ccminer/start.sh

# ------------------------------------------------------------
# systemd auto-start service
# ------------------------------------------------------------
sudo tee /etc/systemd/system/verus-miner.service > /dev/null <<EOF
[Unit]
Description=Verus CPU Miner
After=network.target

[Service]
User=$USER
WorkingDirectory=/home/$USER/ccminer
ExecStart=/home/$USER/ccminer/start.sh
Restart=always
Nice=10
CPUWeight=90

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable verus-miner.service

echo ""
echo "=============================================="
echo "INSTALLATION COMPLETE"
echo "Edit wallet address:"
echo "nano ~/ccminer/start.sh"
echo ""
echo "Start miner now:"
echo "sudo systemctl start verus-miner"
echo ""
echo "View logs:"
echo "journalctl -u verus-miner -f"
echo "=============================================="
