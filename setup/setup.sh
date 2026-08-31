#!/bin/bash

MISSING_TOOLS=()
FAILED_TOOLS=()

echo "=== Linux Developer Environment Setup ==="
echo ""

check_command() {
	if command -v "$1" >/dev/null 2>&1; then
		echo "✓ $1 is installed"
	else
		MISSING_TOOLS+=("$1")
		echo "✗ $1 is not installed"
	fi
}

REQUIRED_TOOLS=("git" "python3" "curl" "htop")

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

	echo ""
	read -r -p "Install missing tools? [y/N]: " answer

	if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
		echo ""
		echo "Updating package lists..."

		if sudo apt update; then
			echo "Package lists updated successfully."
		else
			echo "Failed to update package lists."
			exit 1
		fi

		echo ""
		echo "Installing missing tools..."

		for tool in "${MISSING_TOOLS[@]}"; do
			echo "Installing $tool..."

			if sudo apt install -y "$tool"; then
				echo "✓ $tool installed successfully"
			else
				echo "✗ Failed to install $tool"
			fi

		done

		echo ""
		echo "Verifying installation..."

		for tool in "${MISSING_TOOLS[@]}"; do
			if command -v "$tool" >/dev/null 2>&1; then
				echo "✓ $tool is available"
			else
				FAILED_TOOLS+=("$tool")
				echo "✗ $tool is still missing"
			fi

		done

		if [[ ${#FAILED_TOOLS[@]} -eq 0 ]]; then
			echo ""
			echo "Setup completed successfully."

			exit 0
		else
			echo ""
			echo "Setup failed for:"

			for tool in "${FAILED_TOOLS[@]}"; do
				echo "- $tool"
			done

			exit 1
		fi

	else
		echo ""
		echo "Installation skipped."
	fi

	exit 1
fi
