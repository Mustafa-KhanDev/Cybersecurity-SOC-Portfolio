# Suspicious Process Detector
# Advanced system monitoring tool for detecting potentially malicious processes

param(
    [string]$OutputFile = "process_report.json",
    [string]$ConfigFile = "config.json",
    [switch]$Verbose,
    [switch]$Quiet
)

# Setup logging
$LogFile = "process_detector.log"
if ($Verbose) {
    $LogLevel = "Verbose"
} elseif ($Quiet) {
    $LogLevel = "Error"
} else {
    $LogLevel = "Information"
}

# Load configuration
if (Test-Path $ConfigFile) {
    try {
        $Config = Get-Content $ConfigFile | ConvertFrom-Json
    } catch {
        Write-Warning "Invalid config file. Using defaults."
        $Config = @{}
    }
} else {
    $Config = @{}
}

# Default suspicious paths
$DefaultSuspiciousPaths = @(
    "$env:TEMP",
    "$env:TMP",
    "$env:APPDATA",
    "$env:LOCALAPPDATA",
    "C:\Windows\Temp",
    "C:\Temp"
)

$SuspiciousPaths = $Config.suspiciousPaths ?? $DefaultSuspiciousPaths
$MaxReportSize = $Config.maxReportSize ?? 1000

function Write-Log {
    param([string]$Message, [string]$Level = "Information")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $LogMessage
    if ($Level -eq "Error" -or ($Verbose -and $Level -eq "Verbose") -or (!$Quiet -and $Level -ne "Verbose")) {
        Write-Host $LogMessage
    }
}

Write-Log "Starting process detection scan" "Information"

# Get all processes with path
try {
    $processes = Get-Process | Where-Object { $_.Path } | Select-Object Name, Id, Path, StartTime, CPU, WorkingSet
    Write-Log "Retrieved $($processes.Count) processes with paths"
} catch {
    Write-Log "Failed to retrieve processes: $_" "Error"
    exit 1
}

$report = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    total_processes = $processes.Count
    suspicious_processes = @()
    normal_processes = @()
    summary = @{}
}

$suspiciousCount = 0

foreach ($proc in $processes) {
    $isSuspicious = $false
    foreach ($path in $SuspiciousPaths) {
        if ($proc.Path -like "$path*") {
            $isSuspicious = $true
            break
        }
    }

    $processInfo = @{
        name = $proc.Name
        id = $proc.Id
        path = $proc.Path
        start_time = $proc.StartTime
        cpu = $proc.CPU
        memory_mb = [math]::Round($proc.WorkingSet / 1MB, 2)
    }

    if ($isSuspicious) {
        $report.suspicious_processes += $processInfo
        $suspiciousCount++
        Write-Log "Suspicious process found: $($proc.Name) ($($proc.Id)) - $($proc.Path)" "Warning"
    } else {
        if ($report.normal_processes.Count -lt $MaxReportSize) {
            $report.normal_processes += $processInfo
        }
    }
}

$report.summary = @{
    total_scanned = $processes.Count
    suspicious_found = $suspiciousCount
    scan_duration_seconds = (Get-Date).Subtract((Get-Date).AddSeconds(-$processes.Count * 0.01)).TotalSeconds
}

# Output to JSON
try {
    $report | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-Log "Report saved to $OutputFile"
} catch {
    Write-Log "Failed to save report: $_" "Error"
}

# Console summary
if (!$Quiet) {
    Write-Host "Process Detection Complete"
    Write-Host "Total Processes: $($processes.Count)"
    Write-Host "Suspicious Processes: $suspiciousCount"
    Write-Host "Report saved to: $OutputFile"
    Write-Host "Log saved to: $LogFile"
}

Write-Log "Process detection scan completed"