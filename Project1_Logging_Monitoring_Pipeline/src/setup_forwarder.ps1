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

# Install Splunk Forwarder
Write-Host "Installing Splunk Universal Forwarder..."
Start-Process msiexec.exe -ArgumentList "/i $SplunkInstallerPath /quiet AGREETOLICENSE=Yes" -Wait

# Set admin password
Write-Host "Setting admin password..."
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" edit user admin -password $AdminPassword -auth admin:changeme

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
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" start

Write-Host "Setup complete. Forwarder is sending logs to $IndexerIP:$IndexerPort"