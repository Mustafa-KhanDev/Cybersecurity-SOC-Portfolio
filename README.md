# ASFI Cybersecurity Portfolio

A comprehensive collection of production-level cybersecurity projects demonstrating SOC Analyst competencies. Each project includes source code, documentation, testing, and deployment instructions suitable for enterprise environments.

## Projects Overview

### 1. Logging + Monitoring Pipeline (SIEM-Ready)
**Technology**: Splunk Universal Forwarder, Windows Event Logs
**Skills**: SIEM implementation, log aggregation, dashboard creation
- Automated Splunk Forwarder setup
- Windows Event Log collection
- Custom SIEM dashboard with security metrics
- Production deployment scripts

### 2. Failed Login Monitor + Alerting
**Technology**: Splunk SPL, Detection Engineering
**Skills**: Threat detection, query optimization, alerting
- Advanced brute force detection logic
- Real-time alerting configuration
- Performance-optimized queries
- Enterprise Security integration

### 3. Email Phishing Reporting Script
**Technology**: Python, Email Parsing
**Skills**: Automation, artifact extraction, reporting
- Multi-file batch processing
- Comprehensive email analysis
- JSON reporting for SIEM integration
- Unit testing and logging

### 4. Suspicious Process Detector
**Technology**: PowerShell, System Monitoring
**Skills**: Digital forensics, anomaly detection, reporting
- Advanced process enumeration
- Configurable detection rules
- JSON output with detailed metadata
- Performance monitoring

### 5. Cloud Least-Privilege IAM Policy Template
**Technology**: Azure RBAC, JSON Policies
**Skills**: Cloud security, identity management, compliance
- Custom role definitions
- Least privilege implementation
- Automated deployment scripts
- Security validation

## Architecture Principles

- **Production-Ready**: Enterprise-grade code with error handling, logging, and testing
- **Modular Design**: Separated concerns with src/, docs/, tests/ structure
- **Comprehensive Documentation**: Detailed READMEs with usage examples
- **Security-First**: Least privilege, input validation, secure configurations
- **Scalable**: Designed for high-volume processing and enterprise deployment

## Getting Started

1. **Clone/Download** the portfolio
2. **Navigate** to desired project directory
3. **Review** `docs/README.md` for detailed instructions
4. **Configure** environment-specific settings
5. **Deploy** using provided scripts

## Prerequisites

- Windows 10+/PowerShell 5.1+ (for Windows projects)
- Python 3.7+ (for Python projects)
- Azure subscription (for cloud projects)
- Splunk Enterprise (for SIEM projects)

## Testing

Each project includes comprehensive testing:
- Unit tests for code components
- Configuration validation
- Integration testing scripts
- Mock data for safe testing

## Deployment

### Local Development
```bash
# Python projects
cd Project3_Email_Phishing_Reporting_Script/src
pip install -r requirements.txt
python phishing_analyzer.py sample.eml

# PowerShell projects
cd Project4_Suspicious_Process_Detector/src
.\suspicious_processes.ps1
```

### Production Deployment
- Use provided deployment scripts
- Configure for your environment
- Implement monitoring and alerting
- Set up automated testing

## Security Considerations

- All projects follow security best practices
- No hardcoded credentials
- Input validation and sanitization
- Secure logging practices
- Least privilege configurations

## Certification Alignment

- **SC-200**: Security Operations Analyst (SIEM, detection, cloud security)
- **SC-900**: Microsoft Security, Compliance, and Identity Fundamentals
- **BTL1**: Digital Forensics (process analysis, artifact extraction)

## Contributing

1. Follow established project structures
2. Include comprehensive documentation
3. Add unit tests for new features
4. Test across multiple environments
5. Update this README for new projects

## License

This portfolio is provided for educational and professional development purposes.

## Contact

For questions or collaboration opportunities, please reach out with your specific cybersecurity interests and experience level.

---

*This portfolio demonstrates practical application of cybersecurity concepts in real-world scenarios, suitable for SOC Analyst positions and security certifications.*