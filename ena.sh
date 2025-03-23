#!/bin/bash

# Define variables
VERSION="1.5.0"
ARCH="$(uname -m)"

if [ "$ARCH" == "x86_64" ]; then
  FILE="node_exporter-${VERSION}.linux-amd64.tar.gz"
  URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/$FILE"
elif [ "$ARCH" == "aarch64" ]; then
  FILE="node_exporter-${VERSION}.linux-arm64.tar.gz"
  URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/$FILE"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

# Download Node Exporter
wget $URL -O $FILE

# Extract and move binary
sudo tar -xf $FILE
sudo mv node_exporter-${VERSION}.linux-*/node_exporter /usr/local/bin/

# Clean up
rm -rf node_exporter-${VERSION}.linux-*
rm -f $FILE

# Create node_exporter user
sudo useradd -rs /bin/false node_exporter

# Create systemd service file
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOL
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter \
  --no-collector.arp \
  --no-collector.bcache \
  --no-collector.bonding \
  --no-collector.btrfs \
  --no-collector.dmi \
  --no-collector.edac \
  --no-collector.fibrechannel \
  --no-collector.infiniband \
  --no-collector.hwmon \
  --no-collector.mdadm \
  --no-collector.rapl \
  --no-collector.powersupplyclass \
  --no-collector.tapestats \
  --no-collector.thermal_zone \
  --no-collector.schedstat \
  --no-collector.selinux \
  --no-collector.timex \
  --no-collector.softnet \
  --no-collector.entropy \
  --no-collector.pressure \
  --no-collector.time \
  --collector.ethtool \
  --collector.ethtool.device-include=".*" \
  --collector.ethtool.device-exclude="" \
  --collector.ethtool.metrics-include=^(bw_in_allowance_exceeded|bw_out_allowance_exceeded|pps_allowance_exceeded|linklocal_allowance_exceeded|conntrack_allowance_exceeded|info)$ \
  --collector.netstat

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and restart if already running
sudo systemctl daemon-reload
if sudo systemctl is-active --quiet node_exporter; then
  echo "Node Exporter is already running. Restarting..."
  sudo systemctl restart node_exporter
else
  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter
fi

# Check status
sudo systemctl status node_exporter
