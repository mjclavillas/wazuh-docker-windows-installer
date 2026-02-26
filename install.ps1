$ErrorActionPreference = "Stop"

Write-Output "Checking for Git and Docker..."
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "[+] Installing Git..."
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
}

if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Output "[+] Installing Docker Desktop..."
    winget install --id Docker.DockerDesktop -e --source winget --accept-package-agreements --accept-source-agreements
    Write-Warning "[!] Please restart your computer and start Docker Desktop before running this script again"
    return
}

$targetDir = "$HOME\wazuh-docker"
if (!(Test-Path $targetDir)) {
    Write-Output "[+] Cloning Wazuh Docker repository..."
    git clone https://github.com/wazuh/wazuh-docker.git -b v4.11.2 $targetDir
}
Set-Location "$targetDir\single-node"

Write-Output "[+] Configuring System Memory Limits..."
try {
    wsl -d docker-desktop -u root sysctl -w vm.max_map_count=262144
} catch {
    Write-Warning "[!] WSL fix failed. Injecting 'fix-memory-limit' service into docker-compose.yml..."
    $yamlContent = Get-Content "docker-compose.yml" -Raw
    if ($yamlContent -notmatch "fix-memory-limit") {
        $fixService = @"
  fix-memory-limit:
    image: alpine:latest
    command: sysctl -w vm.max_map_count=262144
    privileged: true
    restart: "no"
"@
        $yamlContent = $yamlContent -replace "services:", "services:`n$fixService"
        Set-Content "docker-compose.yml" $yamlContent
    }
}

Write-Output "[+] Generating SSL Certificates..."
docker-compose -f generate-indexer-certs.yml run --rm generator

Write-Output "[+] Starting Wazuh deployment..."
docker-compose up -d

Write-Output "`n==============================================="
Write-Output "Wazuh is starting up!"
Write-Output "Wait 2-3 minutes for the dashboard to initialize."
Write-Output "URL: https://localhost"
Write-Output "User: admin"
Write-Output "Pass: SecretPassword"
Write-Output "==============================================="