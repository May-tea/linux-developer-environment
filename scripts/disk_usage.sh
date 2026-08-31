#!/bin/bash

read -r TOTAL USED AVAILABLE USAGE <<< "$(df -h / | awk '$6=="/" {print $2, $3, $4, $5}')"

echo "=== Disk Usage ==="

echo "Mount point: /"
echo "Total: $TOTAL"
echo "Used: $USED"
echo "Available: $AVAILABLE"
echo "Usage: $USAGE"
