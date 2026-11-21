#!/bin/bash
exec > >(tee -a /var/log/userdata.log) 2>&1

ZIP=/home/ec2-user/fake-service.zip
BIN=/usr/local/bin/account-service

# make sure unzip exists (AL2023 minimal images may lack it)
command -v unzip >/dev/null || dnf install -y unzip

# wait until the zip exists AND is complete (max ~10 min)
for i in $(seq 1 120); do
  if [ -f "$ZIP" ] && unzip -tq "$ZIP" >/dev/null 2>&1; then
    echo "zip is ready"; break
  fi
  sleep 5
done
unzip -tq "$ZIP" >/dev/null 2>&1 || { echo "ERROR: zip missing or corrupt"; exit 1; }

# unzip
cd /home/ec2-user
unzip -o fake-service.zip

# install binary
mv -f fake-service "$BIN"
chmod +x "$BIN"

# create user and set ownership
id account-admin >/dev/null 2>&1 || useradd -r -s /sbin/nologin account-admin
chown account-admin:account-admin "$BIN"

# systemd unit
tee /etc/systemd/system/account.service << 'EOF'
[Unit]
Description=HashiCorp demo account-service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=account-admin
Group=account-admin
Environment="LISTEN_ADDR=0.0.0.0:9092"
Environment="MESSAGE=Account App"
Environment="UPSTREAM_URIS=http://__STATEMENT_ALB_DNS__"
Environment="NAME=Account App (Fake Service)"
ExecStart=/usr/local/bin/account-service
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now account.service
systemctl status account.service --no-pager