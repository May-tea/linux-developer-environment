#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASH_ALIASES_SOURCE="$PROJECT_DIR/config/bash_aliases"
ENVIRONMENT_SOURCE="$PROJECT_DIR/config/environment"
USER_BASH_ALIASES="$HOME/.bash_aliases"
USER_BASHRC="$HOME/.bashrc"

MISSING_TOOLS=()
FAILED_TOOLS=()

echo "=== Linux Developer Environment Setup ==="
echo ""

configure_environment() {
	echo ""
	echo "Configuring Bash environment..."

	if [[ ! -f "$BASH_ALIASES_SOURCE" ]]; then
		echo "✗ Bash aliases file not found: $BASH_ALIASES_SOURCE"
		return 1
	fi

	if [[ ! -f "$ENVIRONMENT_SOURCE" ]]; then
		echo "✗ Environment file not found: $ENVIRONMENT_SOURCE"
		return 1
	fi

	if [[ -L "$USER_BASH_ALIASES" ]]; then
		if [[ "$(readlink -f "$USER_BASH_ALIASES")" == "$(readlink -f "$BASH_ALIASES_SOURCE")" ]]; then
			echo "✓ Bash aliases already configured"
		else
			echo "✗ $USER_BASH_ALIASES already points to another file"
			return 1
		fi
	elif [[ -e "$USER_BASH_ALIASES" ]]; then
		echo "✗ $USER_BASH_ALIASES already exists and is not a symlink"
		echo "  Please back it up or remove it before running setup again."
		return 1
	else
		ln -s "$BASH_ALIASES_SOURCE" "$USER_BASH_ALIASES"
		echo "✓ Bash aliases configured"
	fi

	local environment_line="source \"$ENVIRONMENT_SOURCE\""

	if grep -Fq "config/environment" "$USER_BASHRC"; then
		echo "✓ Environment configuration already configured"
	else
		printf '\n# Linux Developer Environment\n%s\n' "$environment_line" >>"$USER_BASHRC"
		echo "✓ Environment configuration added to ~/.bashrc"
	fi

	echo "Bash environment configuration completed."
}

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

check_sudo() {
	if ! sudo -v; then
		echo "Error: sudo access is required to install missing tools."
		exit 1
	fi
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

	if configure_environment; then
		echo ""
		echo "Setup completed successfully."
		exit 0
	else
		echo ""
		echo "Environment configuration failed."
		exit 1
	fi
else
	echo ""
	echo "Some required tools are missing."

	for tool in "${MISSING_TOOLS[@]}"; do
		echo "- $tool"
	done

	echo ""
	read -r -p "Install missing tools? [y/N]: " answer

	if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
		check_sudo

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
			if configure_environment; then
				echo ""
				echo "Setup completed successfully."
				exit 0
			else
				echo ""
				echo "Environment configuration failed."
				exit 1
			fi
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
