#!/bin/bash
# Pre-uninstallation script for simple-smbd RPM

set -e

PROJECT_NAME="simple-smbd"

# Stop service before removal
if [ "$1" -eq 0 ]; then
    systemctl stop "$simple-smbd" 2>/dev/null || true
    systemctl disable "$simple-smbd" 2>/dev/null || true
fi

exit 0

