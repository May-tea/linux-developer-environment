#!/bin/bash

MISSING_TOOLS=()
FAILED_TOOLS=()

echo "=== Linux Developer Environment Setup ==="
echo ""

detect_os() {
	if [[ ! -f /etc/os-release ]]; then
		echo "Error: Cannot detect operating system."
		exit 1
	fi

	OS_NAME=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f 2)

	echo "OS: $OS_NAME"
}

detect_package_manager() {
	if command -v apt-get >/dev/null 2>&1; then
		PACKAGE_MANAGER="apt-get"
	else
		echo "Error: Unsupported package manager."
		exit 1
	fi

	echo "Package manager: $PACKAGE_MANAGER"
}

install_package() {
	local package="$1"

	echo "Installing $package..."

	if sudo "$PACKAGE_MANAGER" install -y "$package"; then
		echo "✓ $package installed successfully"
		return 0
	else
		echo "✗ Failed to install $package"
		return 1
	fi
}

check_command() {
	if command -v "$1" >/dev/null 2>&1; then
		echo "✓ $1 is installed"
	else
		MISSING_TOOLS+=("$1")
		echo "✗ $1 is not installed"
	fi
}

detect_os
detect_package_manager

echo ""

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

		if sudo "$PACKAGE_MANAGER" update; then
			echo "Package lists updated successfully."
		else
			echo "Failed to update package lists."
			exit 1
		fi

		echo ""
		echo "Installing missing tools..."

		for tool in "${MISSING_TOOLS[@]}"; do
			if ! install_package "$tool"; then
				FAILED_TOOLS+=("$tool")
			fi
		done

		echo ""
		echo "Verifying installation..."

		for tool in "${MISSING_TOOLS[@]}"; do
			if command -v "$tool" >/dev/null 2>&1; then
				echo "✓ $tool is available"
			else
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
