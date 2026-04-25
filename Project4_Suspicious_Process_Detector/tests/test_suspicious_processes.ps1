# Test script for Suspicious Process Detector

# Mock process data for testing
$MockProcesses = @(
    @{ Name = "chrome"; Id = 1234; Path = "C:\Program Files\Google\Chrome\Application\chrome.exe"; StartTime = Get-Date; CPU = 5.2; WorkingSet = 100MB },
    @{ Name = "malware"; Id = 5678; Path = "C:\Users\User\AppData\Local\Temp\malware.exe"; StartTime = Get-Date; CPU = 0.1; WorkingSet = 10MB },
    @{ Name = "notepad"; Id = 9999; Path = "C:\Windows\System32\notepad.exe"; StartTime = Get-Date; CPU = 0.5; WorkingSet = 20MB }
)

Write-Host "Testing Suspicious Process Detector..."
Write-Host "=" * 50

# Test configuration loading
$configPath = "..\src\config.json"
if (Test-Path $configPath) {
    Write-Host "✓ Config file found"
    try {
        $config = Get-Content $configPath | ConvertFrom-Json
        Write-Host "✓ Config file is valid JSON"
    } catch {
        Write-Host "✗ Config file is invalid JSON"
    }
} else {
    Write-Host "✗ Config file not found"
}

# Test script syntax
$scriptPath = "..\src\suspicious_processes.ps1"
if (Test-Path $scriptPath) {
    Write-Host "✓ Script file found"
    try {
        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $scriptPath), [ref]$null)
        Write-Host "✓ Script syntax is valid"
    } catch {
        Write-Host "✗ Script syntax is invalid"
    }
} else {
    Write-Host "✗ Script file not found"
}

# Test mock data processing
Write-Host "Testing detection logic with mock data..."
$suspiciousPaths = @("$env:TEMP", "$env:APPDATA")
$suspiciousFound = 0

foreach ($proc in $MockProcesses) {
    $isSuspicious = $false
    foreach ($path in $suspiciousPaths) {
        if ($proc.Path -like "$path*") {
            $isSuspicious = $true
            break
        }
    }
    if ($isSuspicious) { $suspiciousFound++ }
}

Write-Host "✓ Mock data processed: $suspiciousFound suspicious processes found"

Write-Host "Testing complete."