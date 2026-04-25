# Configuration Validation Script
# Validates Splunk forwarder configuration files

param(
    [string]$ConfigPath = "..\src"
)

Write-Host "Validating Splunk Forwarder Configurations..."
Write-Host "=" * 50

# Check inputs.conf
$inputsPath = Join-Path $ConfigPath "inputs.conf"
if (Test-Path $inputsPath) {
    Write-Host "✓ inputs.conf found"
    $inputsContent = Get-Content $inputsPath
    if ($inputsContent -match "\[WinEventLog://") {
        Write-Host "✓ WinEventLog stanzas present"
    } else {
        Write-Host "✗ No WinEventLog stanzas found"
    }
} else {
    Write-Host "✗ inputs.conf not found"
}

# Check outputs.conf
$outputsPath = Join-Path $ConfigPath "outputs.conf"
if (Test-Path $outputsPath) {
    Write-Host "✓ outputs.conf found"
    $outputsContent = Get-Content $outputsPath
    if ($outputsContent -match "server =") {
        Write-Host "✓ Server configuration present"
    } else {
        Write-Host "✗ No server configuration found"
    }
} else {
    Write-Host "✗ outputs.conf not found"
}

# Check dashboard.xml
$dashboardPath = Join-Path $ConfigPath "dashboard.xml"
if (Test-Path $dashboardPath) {
    Write-Host "✓ dashboard.xml found"
    $dashboardContent = Get-Content $dashboardPath
    if ($dashboardContent -match "<form>") {
        Write-Host "✓ Valid XML structure"
    } else {
        Write-Host "✗ Invalid XML structure"
    }
} else {
    Write-Host "✗ dashboard.xml not found"
}

Write-Host "Validation complete."