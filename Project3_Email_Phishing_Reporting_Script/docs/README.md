# Email Phishing Reporting Script

A comprehensive Python application for automated analysis and artifact extraction from phishing emails in EML format. Designed for SOC analysts to rapidly triage and report on suspicious emails.

## Features

- **Multi-file Processing**: Analyze multiple EML files in batch
- **Comprehensive Extraction**:
  - Sender IP from email headers
  - Subject and metadata
  - URLs and cryptographic hashes from body
  - Attachment information
- **Advanced Output**: JSON reports for integration with other tools
- **Logging**: Configurable logging with file and console output
- **Error Handling**: Robust parsing with detailed error reporting

## Installation

### Prerequisites
- Python 3.7+
- pip package manager

### Setup
```bash
cd src
pip install -r requirements.txt
```

## Usage

### Basic Usage
```bash
python phishing_analyzer.py email.eml
```

### Advanced Usage
```bash
# Analyze multiple files
python phishing_analyzer.py email1.eml email2.eml email3.eml

# Specify output file
python phishing_analyzer.py -o custom_report.json email.eml

# Verbose logging
python phishing_analyzer.py -v email.eml

# Quiet mode
python phishing_analyzer.py -q email.eml
```

### Command Line Options

- `eml_files`: One or more EML files to analyze (required)
- `-o, --output`: Output JSON file path (default: phishing_report.json)
- `-v, --verbose`: Enable debug logging
- `-q, --quiet`: Suppress non-error output

## Output Format

The tool generates a JSON report with the following structure:

```json
[
  {
    "file": "path/to/email.eml",
    "sender": "attacker@example.com",
    "recipient": "victim@company.com",
    "date": "Wed, 25 Apr 2026 10:00:00 +0000",
    "subject": "Urgent: Account Verification",
    "sender_ip": "192.168.1.100",
    "urls": ["http://phish-site.com/login"],
    "hashes": ["d41d8cd98f00b204e9800998ecf8427e"],
    "attachments": [
      {
        "filename": "invoice.pdf",
        "content_type": "application/pdf",
        "size": 102400
      }
    ],
    "body_length": 2048
  }
]
```

## Technical Details

### IP Extraction
- Parses Received headers in reverse chronological order
- Uses regex to identify IPv4 addresses
- Returns the first valid IP found (typically sender's IP)

### URL and Hash Detection
- URLs: Regex pattern for HTTP/HTTPS links
- Hashes: MD5 (32 chars), SHA1 (40 chars), SHA256 (64 chars)
- Case-insensitive matching

### Attachment Analysis
- Identifies all attachments with metadata
- Reports filename, MIME type, and size
- Does not extract or analyze attachment content

### Error Handling
- Continues processing other files if one fails
- Logs detailed error information
- Graceful handling of malformed emails

## Integration Examples

### With SIEM Systems
```python
import json
from phishing_analyzer import PhishingAnalyzer

analyzer = PhishingAnalyzer('INFO')
results = analyzer.analyze_email('suspicious.eml')
# Send to SIEM API
```

### Batch Processing Script
```bash
#!/bin/bash
for eml in *.eml; do
    python phishing_analyzer.py "$eml"
done
```

## Testing

Run the test suite:
```bash
cd tests
python -m pytest test_phishing_analyzer.py -v
```

## Security Considerations

- Does not execute or render email content
- Safe parsing of potentially malicious emails
- No network connections made during analysis
- Logs do not contain sensitive email content

## Performance

- Processes typical emails in <1 second
- Memory efficient for large email batches
- Scales linearly with file count
- Optimized regex patterns for fast matching

## Files Structure

```
src/
├── phishing_analyzer.py     # Main application
└── requirements.txt         # Python dependencies

docs/
└── README.md                # This documentation

tests/
├── test_phishing_analyzer.py # Unit tests
└── sample.eml              # Test email sample
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

This tool streamlines phishing analysis workflows, reducing manual effort and improving response times in cybersecurity operations.