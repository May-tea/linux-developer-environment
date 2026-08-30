#!/bin/bash

echo "=== System Information ==="

echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Kernel: $(uname -r)"
echo "Shell: $SHELL"
echo "Current directory: $(pwd)"
