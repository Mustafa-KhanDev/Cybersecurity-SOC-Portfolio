# Detection Engineering Lab: Failed Login Monitor + Alerting

This project implements advanced detection logic for identifying brute force authentication attacks in enterprise environments using Splunk SPL (Search Processing Language).

## Detection Overview

The brute force detection identifies successful logins that follow multiple failed attempts from the same source IP, indicating a potential credential stuffing or password spraying attack.

## Technical Implementation

### Core Detection Logic

The SPL query uses `streamstats` with a sliding window approach to count failed login events preceding each successful login.

**Key Components:**
- **Data Source**: Windows Security Event Logs (Events 4625 - Failed Login, 4624 - Successful Login)
- **Windowing**: 6-event sliding window per source IP
- **Threshold**: 5+ failed logins followed by success
- **Grouping**: By source IP to detect targeted attacks

### Query Breakdown

1. **Base Search**: Filter for authentication events
2. **Sorting**: Ensure chronological order
3. **Streamstats**: Count failed events in sliding window
4. **Filtering**: Identify successful logins with high failed count
5. **Output**: Relevant fields for investigation

## Alert Configuration

### Splunk Alert Setup

1. **Search**: Use the provided SPL query
2. **Trigger Conditions**:
   - Trigger when: Number of Results > 0
   - Trigger: Per Result
3. **Throttle**: 1 hour window, suppress subsequent alerts
4. **Severity**: High
5. **Actions**:
   - Send email to SOC team
   - Create notable event in Enterprise Security
   - Run adaptive response action (block IP, etc.)

### Advanced Alert Features

- **Real-time Scheduling**: Run every 5 minutes
- **Custom Trigger**: Alert on first result only
- **Expiration**: 24 hours
- **Tags**: brute_force, authentication, security

## Testing and Validation

### Test Data Generation

To test the detection:

1. Simulate failed logins from same IP
2. Follow with successful login
3. Verify alert triggers

### False Positive Mitigation

- **Whitelisting**: Exclude known admin IPs
- **Time Windows**: Consider only events within 1 hour
- **User Context**: Check if user normally fails logins
- **Geolocation**: Flag unusual locations

## Integration with SIEM

### Enterprise Security Correlation

- Map to "Brute Force Attack" use case
- Create risk modifiers for affected users
- Generate threat intelligence reports

### Custom Dashboard

Create a dashboard showing:
- Brute force attempts over time
- Top attacking IPs
- Affected user accounts
- Geographic distribution

## Performance Optimization

- **Index Optimization**: Ensure proper field extractions
- **Search Efficiency**: Use `tstats` for large datasets
- **Caching**: Implement summary indexing for historical data
- **Parallel Processing**: Distribute across search heads

## Production Considerations

### Tuning for Environment

- Adjust threshold based on normal failure rates
- Consider account lockout policies
- Integrate with MFA requirements
- Monitor for evasion techniques (slow brute force)

### Compliance Alignment

- Aligns with NIST CSF, MITRE ATT&CK (T1110)
- Supports SOC 2, ISO 27001 requirements
- Provides audit trails for investigations

## Files Structure

```
src/
└── brute_force_detection.spl    # Core detection query

docs/
└── README.md                    # This documentation

tests/
└── test_data_sample.csv         # Sample event data for testing
```

## Metrics and KPIs

- **Detection Rate**: Percentage of actual attacks detected
- **False Positive Rate**: Alerts per legitimate login attempts
- **Mean Time to Detect**: Average time from attack start to alert
- **Mean Time to Respond**: Average time to investigate and remediate

This detection engineering project demonstrates advanced threat hunting and automated response capabilities essential for modern SOC operations.