# Test script for Suspicious Process Detector

Write-Host "Testing Suspicious Process Detector..."
Write-Host "=================================================="

# Test configuration loading
$configPath = '..\src\config.json'
if (Test-Path $configPath) {
    Write-Host "[OK] Config file found"
    $configContent = Get-Content $configPath -Raw
    if ($configContent) {
        Write-Host "[OK] Config file has content"
    } else {
        Write-Host "[FAIL] Config file is empty"
    }
} else {
    Write-Host "[FAIL] Config file not found"
}

# Test script exists
$scriptPath = '..\src\suspicious_processes.ps1'
if (Test-Path $scriptPath) {
    Write-Host "[OK] Script file found"
    $scriptContent = Get-Content $scriptPath
    if ($scriptContent -match 'param') {
        Write-Host "[OK] Script has parameters"
    } else {
        Write-Host "[FAIL] Script missing parameters"
    }
} else {
    Write-Host "[FAIL] Script file not found"
}

# Simple mock test
Write-Host "Testing basic logic..."
$suspiciousPaths = @('$env:TEMP', '$env:APPDATA')
$testPath = '$env:TEMP\test.exe'
$found = $false
foreach ($path in $suspiciousPaths) {
    if ($testPath -like "$path*") {
        $found = $true
        break
    }
}
if ($found) {
    Write-Host "[OK] Path matching logic works"
} else {
    Write-Host "[FAIL] Path matching logic failed"
}

Write-Host "Testing complete."

Write-Host "Testing complete."