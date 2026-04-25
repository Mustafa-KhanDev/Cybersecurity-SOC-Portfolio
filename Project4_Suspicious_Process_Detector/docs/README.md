# Suspicious Process Detector

An advanced PowerShell application for system monitoring and anomaly detection in process execution. Identifies potentially malicious processes based on execution locations and provides comprehensive reporting for digital forensics and incident response.

## Features

- **Comprehensive Process Enumeration**: Captures all running processes with detailed metadata
- **Configurable Detection Rules**: Customizable suspicious path definitions
- **Advanced Reporting**: JSON output with process details, CPU, memory usage
- **Logging System**: Configurable logging with file and console output
- **Performance Monitoring**: Tracks scan duration and resource usage
- **Batch Processing**: Efficient handling of large process lists

## Installation

### Prerequisites
- Windows PowerShell 5.1+ or PowerShell Core 7+
- Administrative privileges for full process information

### Setup
No additional setup required. Run directly from PowerShell.

## Usage

### Basic Usage
```powershell
.\suspicious_processes.ps1
```

### Advanced Usage
```powershell
# Custom output file
.\suspicious_processes.ps1 -OutputFile "custom_report.json"

# Use custom config
.\suspicious_processes.ps1 -ConfigFile "my_config.json"

# Verbose logging
.\suspicious_processes.ps1 -Verbose

# Quiet mode
.\suspicious_processes.ps1 -Quiet
```

### Command Line Options

- `OutputFile`: JSON report file path (default: process_report.json)
- `ConfigFile`: Configuration file path (default: config.json)
- `Verbose`: Enable detailed logging
- `Quiet`: Suppress console output except errors

## Configuration

The `config.json` file allows customization:

```json
{
  "suspiciousPaths": [
    "%TEMP%",
    "%TMP%",
    "%APPDATA%",
    "C:\\Windows\\Temp"
  ],
  "maxReportSize": 500,
  "excludeProcesses": [
    "explorer.exe"
  ]
}
```

### Configuration Options

- **suspiciousPaths**: Array of paths considered suspicious
- **maxReportSize**: Maximum number of normal processes to include in report
- **excludeProcesses**: Process names to exclude from suspicious checks

## Output Format

Generates a JSON report with the following structure:

```json
{
  "timestamp": "2026-04-25 12:00:00",
  "total_processes": 150,
  "suspicious_processes": [
    {
      "name": "malware.exe",
      "id": 1234,
      "path": "C:\\Users\\User\\AppData\\Local\\Temp\\malware.exe",
      "start_time": "2026-04-25T10:00:00",
      "cpu": 15.2,
      "memory_mb": 45.6
    }
  ],
  "normal_processes": [...],
  "summary": {
    "total_scanned": 150,
    "suspicious_found": 1,
    "scan_duration_seconds": 0.5
  }
}
```

## Technical Details

### Process Information Collected

- Process name and ID
- Executable path
- Start time
- CPU usage percentage
- Memory usage in MB

### Detection Logic

- Path-based analysis against configurable suspicious locations
- Environment variable expansion (%TEMP%, %APPDATA%, etc.)
- Case-insensitive path matching

### Performance Optimization

- Efficient process enumeration
- Minimal memory footprint
- Configurable report size limits
- Fast JSON serialization

## Integration Examples

### With SIEM Systems
```powershell
# Run scan and send to SIEM
.\suspicious_processes.ps1 -OutputFile "scan.json"
# Use API to upload scan.json to SIEM
```

### Scheduled Task
```powershell
# Create scheduled task for regular scanning
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument ".\suspicious_processes.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "09:00"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ProcessMonitor" -RunLevel Highest
```

### PowerShell Module
```powershell
# Import as module
Import-Module .\suspicious_processes.ps1
# Use functions directly
Get-SuspiciousProcesses
```

## Testing

Run the test suite:
```powershell
cd tests
.\test_suspicious_processes.ps1
```

## Security Considerations

- Requires administrative privileges for complete process information
- Logs sensitive system information - secure log files
- No network communications - analysis is local only
- Safe for production environments

## Troubleshooting

### Common Issues

**Access Denied Errors**
- Run as Administrator
- Check antivirus exclusions

**No Processes Found**
- Verify PowerShell execution policy
- Check for filtering software

**Large Report Files**
- Adjust `maxReportSize` in config
- Use compression for storage

### Log Analysis

Check `process_detector.log` for detailed operation information.

## Files Structure

```
src/
├── suspicious_processes.ps1    # Main application
└── config.json                # Configuration file

docs/
└── README.md                  # This documentation

tests/
├── test_suspicious_processes.ps1  # Test suite
└── mock_processes.json        # Test data
```

## Contributing

1. Follow PowerShell best practices
2. Add tests for new features
3. Update documentation
4. Test on multiple Windows versions

## License

This project is licensed under the MIT License.

This tool provides critical visibility into system processes, enabling rapid identification of potential security threats and supporting digital forensics investigations.