# Linux Developer Environment

A practical Linux developer environment setup project built with Bash scripting.

This project automates common developer environment tasks such as system information gathering, disk usage monitoring, tool checking, tool installation, Bash aliases, and environment configuration.

## Features

- Collect system information
- Monitor disk usage
- Check required developer tools
- Automatically install missing tools
- Configure Bash aliases
- Manage environment variables
- Protect local environment files with `.gitignore`

## Project Structure

```text
linux-developer-environment/
├── config/
│   ├── bash_aliases
│   └── environment
├── notes/
├── scripts/
│   ├── system_info.sh
│   └── disk_usage.sh
├── setup/
│   └── setup.sh
├── .env.example
├── .gitignore
└── README.md
```

## Installation

Clone the repository:

```bash
git clone git@github.com:May-tea/linux-developer-environment.git
cd linux-developer-environment
chmod +x setup/setup.sh
./setup/setup.sh
```

## Usage

### System Information

Display basic system information:

```bash
./scripts/system_info.sh
```

### Disk Usage

Display disk usage for the root filesystem:

```bash
./scripts/disk_usage.sh
```

### Bash Aliases

Load the project Bash aliases:

```bash
source config/bash_aliases
```

Available aliases include:

```text
ll    List files in long format
la    List all files
l     List files with indicators
..    Move to parent directory
...   Move two directories up
gs    Git status
gl    Git log
c     Clear terminal
```

### Environment Configuration

Load the project environment variables:

```bash
source config/environment
```

## Requirements

- Ubuntu 26.04 LTS or compatible Debian-based Linux distribution
- Bash
- Git
- Python 3
- curl
- htop
- sudo access for installing missing packages

## Example Output

### System Information

```text
=== System Information ===
Hostname: <hostname>
User: <username>
OS: Ubuntu 26.04.1 LTS
Kernel: 6.18.33.2-microsoft-standard-WSL2
Uptime: up 4 hours, 30 minutes
CPU: 12th Gen Intel(R) Core(TM) i7-12650H
Memory: 1.1Gi / 7.6Gi
Disk: 1% used
Shell: /bin/bash
Current directory: <project-directory>
```

### Disk Usage

```text
=== Disk Usage ===
Mount point: /
Total: 1007G
Used: 2.5G
Available: 954G
Usage: 1%
```
