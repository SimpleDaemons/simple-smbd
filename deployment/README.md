# simple-smbd Deployment

This directory contains deployment configurations and examples for simple-smbd.

## Directory Structure

```
deployment/
├── systemd/                    # Linux systemd service files
│   └── simple-smbd.service
├── launchd/                    # macOS launchd service files
│   └── com.simple-smbd.simple-smbd.plist
├── logrotate.d/                # Linux log rotation configuration
│   └── simple-smbd
├── windows/                    # Windows service management
│   └── simple-smbd.service.bat
└── examples/                   # Deployment examples
    └── docker/                 # Docker deployment examples
        ├── docker-compose.yml
        └── README.md
```

## Platform-Specific Deployment

### Linux (systemd)

1. **Install the service file:**
   ```bash
   sudo cp deployment/systemd/simple-smbd.service /etc/systemd/system/
   sudo systemctl daemon-reload
   ```

2. **Create user and group:**
   ```bash
   sudo useradd --system --no-create-home --shell /bin/false simple-smbd
   ```

3. **Enable and start the service:**
   ```bash
   sudo systemctl enable simple-smbd
   sudo systemctl start simple-smbd
   ```

4. **Check status:**
   ```bash
   sudo systemctl status simple-smbd
   sudo journalctl -u simple-smbd -f
   ```

### macOS (launchd)

1. **Install the plist file:**
   ```bash
   sudo cp deployment/launchd/com.simple-smbd.simple-smbd.plist /Library/LaunchDaemons/
   sudo chown root:wheel /Library/LaunchDaemons/com.simple-smbd.simple-smbd.plist
   ```

2. **Load and start the service:**
   ```bash
   sudo launchctl load /Library/LaunchDaemons/com.simple-smbd.simple-smbd.plist
   sudo launchctl start com.simple-smbd.simple-smbd
   ```

3. **Check status:**
   ```bash
   sudo launchctl list | grep simple-smbd
   tail -f /var/log/simple-smbd.log
   ```

### Windows

1. **Run as Administrator:**
   ```cmd
   # Install service
   deployment\windows\simple-smbd.service.bat install
   
   # Start service
   deployment\windows\simple-smbd.service.bat start
   
   # Check status
   deployment\windows\simple-smbd.service.bat status
   ```

2. **Service management:**
   ```cmd
   # Stop service
   deployment\windows\simple-smbd.service.bat stop
   
   # Restart service
   deployment\windows\simple-smbd.service.bat restart
   
   # Uninstall service
   deployment\windows\simple-smbd.service.bat uninstall
   ```

## Log Rotation (Linux)

1. **Install logrotate configuration:**
   ```bash
   sudo cp deployment/logrotate.d/simple-smbd /etc/logrotate.d/
   ```

2. **Test logrotate configuration:**
   ```bash
   sudo logrotate -d /etc/logrotate.d/simple-smbd
   ```

3. **Force log rotation:**
   ```bash
   sudo logrotate -f /etc/logrotate.d/simple-smbd
   ```

## Docker Deployment

See [examples/docker/README.md](examples/docker/README.md) for detailed Docker deployment instructions.

### Quick Start

```bash
# Build and run with Docker Compose
cd deployment/examples/docker
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs simple-smbd
```

## Configuration

### Service Configuration

Each platform has specific configuration requirements:

- **Linux**: Edit `/etc/systemd/system/simple-smbd.service`
- **macOS**: Edit `/Library/LaunchDaemons/com.simple-smbd.simple-smbd.plist`
- **Windows**: Edit the service binary path in the batch file

### Application Configuration

Place your application configuration in:
- **Linux/macOS**: `/etc/simple-smbd/simple-smbd.conf`
- **Windows**: `%PROGRAMFILES%\simple-smbd\simple-smbd.conf`

## Security Considerations

### User and Permissions

1. **Create dedicated user:**
   ```bash
   # Linux
   sudo useradd --system --no-create-home --shell /bin/false simple-smbd
   
   # macOS
   sudo dscl . -create /Users/_simple-smbd UserShell /usr/bin/false
   sudo dscl . -create /Users/_simple-smbd UniqueID 200
   sudo dscl . -create /Users/_simple-smbd PrimaryGroupID 200
   sudo dscl . -create /Groups/_simple-smbd GroupID 200
   ```

2. **Set proper permissions:**
   ```bash
   # Configuration files
   sudo chown root:simple-smbd /etc/simple-smbd/simple-smbd.conf
   sudo chmod 640 /etc/simple-smbd/simple-smbd.conf
   
   # Log files
   sudo chown simple-smbd:simple-smbd /var/log/simple-smbd/
   sudo chmod 755 /var/log/simple-smbd/
   ```

### Firewall Configuration

Configure firewall rules as needed:

```bash
# Linux (ufw)
sudo ufw allow /tcp

# Linux (firewalld)
sudo firewall-cmd --permanent --add-port=/tcp
sudo firewall-cmd --reload

# macOS
sudo pfctl -f /etc/pf.conf
```

## Monitoring

### Health Checks

1. **Service status:**
   ```bash
   # Linux
   sudo systemctl is-active simple-smbd
   
   # macOS
   sudo launchctl list | grep simple-smbd
   
   # Windows
   sc query simple-smbd
   ```

2. **Port availability:**
   ```bash
   netstat -tlnp | grep 
   ss -tlnp | grep 
   ```

3. **Process monitoring:**
   ```bash
   ps aux | grep simple-smbd
   top -p $(pgrep simple-smbd)
   ```

### Log Monitoring

1. **Real-time logs:**
   ```bash
   # Linux
   sudo journalctl -u simple-smbd -f
   
   # macOS
   tail -f /var/log/simple-smbd.log
   
   # Windows
   # Use Event Viewer or PowerShell Get-WinEvent
   ```

2. **Log analysis:**
   ```bash
   # Search for errors
   sudo journalctl -u simple-smbd --since "1 hour ago" | grep -i error
   
   # Count log entries
   sudo journalctl -u simple-smbd --since "1 day ago" | wc -l
   ```

## Troubleshooting

### Common Issues

1. **Service won't start:**
   - Check configuration file syntax
   - Verify user permissions
   - Check port availability
   - Review service logs

2. **Permission denied:**
   - Ensure service user exists
   - Check file permissions
   - Verify directory ownership

3. **Port already in use:**
   - Check what's using the port: `netstat -tlnp | grep `
   - Stop conflicting service or change port

4. **Service stops unexpectedly:**
   - Check application logs
   - Verify resource limits
   - Review system logs

### Debug Mode

Run the service in debug mode for troubleshooting:

```bash
# Linux/macOS
sudo -u simple-smbd /usr/local/bin/simple-smbd --debug

# Windows
simple-smbd.exe --debug
```

### Log Levels

Adjust log level for more verbose output:

```bash
# Set log level in configuration
log_level = debug

# Or via environment variable
export SIMPLE-SMBD_LOG_LEVEL=debug
```

## Backup and Recovery

### Configuration Backup

```bash
# Backup configuration
sudo tar -czf simple-smbd-config-backup-$(date +%Y%m%d).tar.gz /etc/simple-smbd/

# Backup logs
sudo tar -czf simple-smbd-logs-backup-$(date +%Y%m%d).tar.gz /var/log/simple-smbd/
```

### Service Recovery

```bash
# Stop service
sudo systemctl stop simple-smbd

# Restore configuration
sudo tar -xzf simple-smbd-config-backup-YYYYMMDD.tar.gz -C /

# Start service
sudo systemctl start simple-smbd
```

## Updates

### Service Update Process

1. **Stop service:**
   ```bash
   sudo systemctl stop simple-smbd
   ```

2. **Backup current version:**
   ```bash
   sudo cp /usr/local/bin/simple-smbd /usr/local/bin/simple-smbd.backup
   ```

3. **Install new version:**
   ```bash
   sudo cp simple-smbd /usr/local/bin/
   sudo chmod +x /usr/local/bin/simple-smbd
   ```

4. **Start service:**
   ```bash
   sudo systemctl start simple-smbd
   ```

5. **Verify update:**
   ```bash
   sudo systemctl status simple-smbd
   simple-smbd --version
   ```
