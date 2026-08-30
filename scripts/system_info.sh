#!/bin/bash

OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '=' -f 2 | cut -d '"' -f 2)
CPU=$(lscpu | grep '^Model name:' | cut -d ':' -f 2 | xargs)
MEMORY=$(free -h | awk '/^Mem:/ {print $3, "/", $2}')
DISK=$(df -h / | awk '$6=="/" {print $5}')

echo "=== System Information ==="

echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "OS: $OS"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "CPU: $CPU"
echo "Memory: $MEMORY"
echo "Disk: $DISK used"
echo "Shell: $SHELL"
echo "Current directory: $(pwd)"
