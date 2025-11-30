#!/bin/bash
# Post-uninstallation script for simple-smbd RPM

set -e

# Reload systemd
systemctl daemon-reload

exit 0

