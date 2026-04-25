# Splunk Forwarder Setup Script
# This script automates the installation and configuration of Splunk Universal Forwarder on Windows

param(
    [string]$SplunkInstallerPath = "C:\Temp\splunkforwarder.msi",
    [string]$IndexerIP = "192.168.1.100",
    [int]$IndexerPort = 9997,
    [string]$AdminPassword = "changeme"
)

# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run as Administrator"
    exit 1
}

# Check if Splunk installer exists
if (-not (Test-Path $SplunkInstallerPath)) {
    Write-Host "Error: Splunk installer not found at $SplunkInstallerPath" -ForegroundColor Red
    exit 1
}

# Validate indexer IP format
if ($IndexerIP -notmatch '^(\d{1,3}\.){3}\d{1,3}$') {
    Write-Host "Error: Invalid indexer IP format: $IndexerIP" -ForegroundColor Red
    exit 1
}

# Validate port
if ($IndexerPort -lt 1 -or $IndexerPort -gt 65535) {
    Write-Host "Error: Invalid port number: $IndexerPort" -ForegroundColor Red
    exit 1
}

# Set admin password
Write-Host "Setting admin password..."
try {
    & "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" edit user admin -password $AdminPassword -auth admin:changeme
    Write-Host "Password set successfully."
} catch {
    Write-Host "Warning: Could not set password automatically. You may need to set it manually." -ForegroundColor Yellow
}

# Copy configs
Write-Host "Configuring inputs and outputs..."
Copy-Item ".\inputs.conf" "C:\Program Files\SplunkUniversalForwarder\etc\system\local\"
Copy-Item ".\outputs.conf" "C:\Program Files\SplunkUniversalForwarder\etc\system\local\"

# Update outputs.conf with provided IP
$outputsContent = Get-Content "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf"
$outputsContent = $outputsContent -replace "192\.168\.1\.100", $IndexerIP
$outputsContent = $outputsContent -replace "9997", $IndexerPort
$outputsContent | Set-Content "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf"

# Start Splunk Forwarder
Write-Host "Starting Splunk Forwarder..."
try {
    & "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" start
    Write-Host "Splunk Forwarder started successfully."
} catch {
    Write-Host "Error: Failed to start Splunk Forwarder: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Setup complete. Forwarder is sending logs to $IndexerIP:$IndexerPort"