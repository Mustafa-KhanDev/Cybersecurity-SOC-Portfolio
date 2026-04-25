# Logging + Monitoring Pipeline (SIEM-Ready)

This comprehensive project implements a production-level logging and monitoring pipeline using Splunk Universal Forwarder to collect Windows Event Logs and send them to a Splunk Enterprise instance for SIEM analysis.

## Architecture Overview

- **Data Collection**: Splunk Universal Forwarder on Windows VM
- **Data Sources**: Windows Security, System, and Application Event Logs
- **Data Transport**: SSL-encrypted TCP to Splunk Indexer
- **Visualization**: Custom Splunk Dashboard for security monitoring

## Prerequisites

- Windows Server/VM with administrative access
- Splunk Enterprise instance (Indexer) running and accessible
- Splunk Universal Forwarder MSI installer downloaded
- Network connectivity between forwarder and indexer

## Installation and Setup

### Step 1: Prepare the Environment

1. Download Splunk Universal Forwarder from [Splunk Downloads](https://www.splunk.com/en_us/download/universal-forwarder.html)
2. Place the MSI in `C:\Temp\splunkforwarder.msi`
3. Ensure firewall allows outbound connections to indexer on port 9997

### Step 2: Run Automated Setup

```powershell
# Run as Administrator
.\setup_forwarder.ps1 -SplunkInstallerPath "C:\Temp\splunkforwarder.msi" -IndexerIP "your.indexer.ip" -IndexerPort 9997 -AdminPassword "securepassword"
```

### Manual Setup (Alternative)

1. Install Splunk Forwarder: `msiexec /i splunkforwarder.msi /quiet AGREETOLICENSE=Yes`
2. Set admin password: `splunk edit user admin -password newpassword`
3. Copy `inputs.conf` and `outputs.conf` to `C:\Program Files\SplunkUniversalForwarder\etc\system\local\`
4. Edit `outputs.conf` with your indexer details
5. Start service: `splunk start`

## Configuration Details

### Inputs Configuration
- Monitors Security log for authentication events (4625, 4624)
- Monitors System log for system events
- Monitors Application log for application errors
- Uses checkpointing to avoid duplicate data on restart

### Outputs Configuration
- Sends data via TCP with compression
- SSL encryption (certificate verification disabled for lab)
- Load balancing support for multiple indexers

## Splunk Indexer Setup

On your Splunk Enterprise instance:

1. Go to Settings > Forwarding and receiving > Receive data
2. Add new receiving port (9997)
3. Ensure SSL is configured if needed

## Dashboard Deployment

1. In Splunk Web, navigate to Search & Reporting > Dashboards
2. Click "Create New Dashboard" > "Import Dashboard from XML"
3. Paste the contents of `dashboard.xml`
4. Save and view the dashboard

The dashboard includes:
- Failed Login trends over time
- Process Creation trends
- Top users with failed logins
- Recent process executions

## Testing and Validation

Run the test script to validate configurations:

```powershell
.\tests\validate_configs.ps1
```

This checks:
- Config file syntax
- Required fields presence
- File permissions

## Troubleshooting

### Forwarder Not Connecting
- Check network connectivity: `telnet indexer_ip 9997`
- Verify indexer is listening: Check Splunk logs on indexer
- Review forwarder logs: `splunk list forward-server`

### No Data Appearing
- Check index permissions on indexer
- Verify sourcetypes match
- Look for parsing errors in Splunk

### Performance Issues
- Adjust `checkpointInterval` in inputs.conf
- Monitor forwarder performance: `splunk status`

## Security Considerations

- Change default admin password
- Enable SSL certificate verification in production
- Restrict forwarder access to indexer
- Regularly update Splunk software

## Production Deployment

For enterprise deployment:
- Use deployment server for centralized config management
- Implement monitoring and alerting for forwarder health
- Set up log rotation and retention policies
- Configure high availability with multiple indexers

## Files Structure

```
src/
├── inputs.conf          # Data collection configuration
├── outputs.conf         # Data forwarding configuration
├── dashboard.xml        # Splunk dashboard definition
└── setup_forwarder.ps1  # Automated installation script

docs/
└── README.md            # This documentation

tests/
└── validate_configs.ps1 # Configuration validation
```

This project demonstrates enterprise-grade SIEM implementation skills suitable for SOC Analyst roles.