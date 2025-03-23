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
