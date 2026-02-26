# Wazuh Docker Windows Installer

**Automated PowerShell script to deploy a Wazuh SIEM on Windows using Docker Desktop.**

This project simplifies the deployment of Wazuh (v4.11.2) by automating prerequisite checks, repository cloning, SSL certificate generation, and critical system configuration (like vm.max_map_count fixes for Indexer stability).

## Features

- **Auto-Prerequisite Check:** Verifies and installs Git and Docker Desktop via Winget.
- **Smart Memory Fix:** Automatically detects WSL2 or Hyper-V backends and applies the required vm.max_map_count (262,144) kernel limit.
- **One-Click Deployment:** Automates the complex certificate generation process and Docker Compose startup.

## Prerequisites

- **Windows 10/11** (with WSL2 or Hyper-V enabled).
- **PowerShell 5.1+** (Run as Administrator).
- **Docker Desktop** (Must be running before starting the script).

## Getting Started

### 1. Clone the Repository

Open your terminal (or Git Bash) and run:

```bash
git clone https://github.com/mjclavillas/wazuh-docker-windows-installer.git
cd wazuh-docker-windows-installer
```

### 2. Run the Installer

Open PowerShell as **Administrator** and run the script:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\install.ps1
```

### 3. Access the Dashboard

Once the containers are healthy (usually takes 2–3 minutes), access the web interface:

- **URL**: https://localhost
- **Username**: admin
- **Password**: SecretPassword

_Note: You will see a certificate warning in your browser. This is normal for self-signed certificates. Click Advanced > Proceed._
