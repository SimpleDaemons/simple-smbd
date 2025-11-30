#!/bin/bash
# Post-installation script for simple-smbd RPM

set -e

PROJECT_NAME="simple-smbd"
SERVICE_USER="smbddev"

# Create service user if it doesn't exist
if ! id "$SERVICE_USER" &>/dev/null; then
    useradd -r -s /sbin/nologin -d /var/lib/$simple-smbd -c "$simple-smbd service user" "$SERVICE_USER"
fi

# Set ownership
chown -R "$SERVICE_USER:$SERVICE_USER" /etc/$simple-smbd 2>/dev/null || true
chown -R "$SERVICE_USER:$SERVICE_USER" /var/log/$simple-smbd 2>/dev/null || true
chown -R "$SERVICE_USER:$SERVICE_USER" /var/lib/$simple-smbd 2>/dev/null || true

# Enable and start service
systemctl daemon-reload
systemctl enable "$simple-smbd" 2>/dev/null || true
systemctl start "$simple-smbd" 2>/dev/null || true

exit 0

