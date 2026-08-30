#!/bin/bash

MISSING_TOOLS=()

echo "=== Linux Developer Environment Setup ==="
echo ""

check_command() {
    if command -v "$1" > /dev/null 2>&1; then
        echo "✓ $1 is installed"
    else
	MISSING_TOOLS+=("$1")
        echo "✗ $1 is not installed"
    fi
}

REQUIRED_TOOLS=("git" "python3" "curl")

for tool in "${REQUIRED_TOOLS[@]}"; do
    check_command "$tool"
done

if [[ ${#MISSING_TOOLS[@]} -eq 0 ]]; then
    echo ""
    echo "All required tools are installed."

    exit 0
else
    echo ""
    echo "Some required tools are missing."

    for tool in "${MISSING_TOOLS[@]}"; do
        echo "- $tool"
    done

    exit 1
fi
