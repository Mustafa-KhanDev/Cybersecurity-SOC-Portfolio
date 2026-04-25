#!/usr/bin/env python3
"""
Email Phishing Reporting Script
Advanced tool for extracting and analyzing phishing email artifacts.
"""

import sys
import re
import csv
import logging
import argparse
from email import policy
from email.parser import BytesParser
from pathlib import Path
from typing import Dict, List, Optional

class PhishingAnalyzer:
    def __init__(self, log_level: str = 'INFO'):
        self.setup_logging(log_level)
        self.logger = logging.getLogger(__name__)

    def setup_logging(self, level: str):
        """Configure logging"""
        numeric_level = getattr(logging, level.upper(), None)
        if not isinstance(numeric_level, int):
            raise ValueError(f'Invalid log level: {level}')

        logging.basicConfig(
            level=numeric_level,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('phishing_analyzer.log'),
                logging.StreamHandler()
            ]
        )

    def extract_sender_ip(self, msg) -> Optional[str]:
        """Extract the sender's IP from Received headers."""
        received_headers = msg.get_all('Received')
        if not received_headers:
            return None

        for header in received_headers:
            ip_match = re.search(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b', header)
            if ip_match:
                return ip_match.group(0)
        return None

    def extract_subject(self, msg) -> str:
        """Extract the Subject line."""
        return msg.get('Subject', 'No Subject')

    def extract_urls_and_hashes(self, text: str) -> tuple[List[str], List[str]]:
        """Extract URLs and hashes from text with improved regex."""
        # Improved URL regex to catch more variations
        url_pattern = r'https?://(?:[-\w.])+(?:[:\d]+)?(?:/(?:[\w/_.])*(?:\?(?:[\w&=%.])*)?(?:#(?:\w*))?)?'
        urls = re.findall(url_pattern, text, re.IGNORECASE)

        # Hash patterns for MD5, SHA1, SHA256, SHA512
        hash_patterns = [
            r'\b[a-fA-F0-9]{32}\b',    # MD5
            r'\b[a-fA-F0-9]{40}\b',    # SHA1
            r'\b[a-fA-F0-9]{64}\b',    # SHA256
            r'\b[a-fA-F0-9]{128}\b'    # SHA512
        ]
        hashes = []
        for pattern in hash_patterns:
            hashes.extend(re.findall(pattern, text))

        return list(set(urls)), list(set(hashes))  # Remove duplicates

    def extract_attachments(self, msg) -> List[Dict]:
        """Extract attachment information."""
        attachments = []
        if msg.is_multipart():
            for part in msg.walk():
                if part.get_content_disposition() == 'attachment':
                    attachments.append({
                        'filename': part.get_filename(),
                        'content_type': part.get_content_type(),
                        'size': len(part.get_payload(decode=True) or b'')
                    })
        return attachments

    def analyze_email(self, eml_file: Path) -> Dict:
        """Analyze the email and extract artifacts."""
        self.logger.info(f"Analyzing email: {eml_file}")

        try:
            with open(eml_file, 'rb') as f:
                msg = BytesParser(policy=policy.default).parse(f)
        except Exception as e:
            self.logger.error(f"Failed to parse email: {e}")
            return {}

        # Extract basic info
        sender_ip = self.extract_sender_ip(msg)
        subject = self.extract_subject(msg)
        sender = msg.get('From', 'Unknown')
        recipient = msg.get('To', 'Unknown')
        date = msg.get('Date', 'Unknown')

        # Extract body text
        body = ""
        if msg.is_multipart():
            for part in msg.walk():
                if part.get_content_type() == 'text/plain':
                    body += part.get_payload(decode=True).decode('utf-8', errors='ignore')
        else:
            body = msg.get_payload(decode=True).decode('utf-8', errors='ignore')

        urls, hashes = self.extract_urls_and_hashes(body)
        attachments = self.extract_attachments(msg)

        result = {
            'file': str(eml_file),
            'sender': sender,
            'recipient': recipient,
            'date': date,
            'subject': subject,
            'sender_ip': sender_ip,
            'urls': urls,
            'hashes': hashes,
            'attachments': attachments,
            'body_length': len(body)
        }

        self.logger.info(f"Analysis complete for {eml_file}")
        return result

    def save_report(self, results: List[Dict], output_file: Path, format: str = 'json'):
        """Save analysis results in specified format."""
        if format.lower() == 'json':
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(results, f, indent=2, ensure_ascii=False)
        elif format.lower() == 'csv':
            if results:
                fieldnames = results[0].keys()
                with open(output_file, 'w', newline='', encoding='utf-8') as f:
                    writer = csv.DictWriter(f, fieldnames=fieldnames)
                    writer.writeheader()
                    writer.writerows(results)
        else:
            raise ValueError(f"Unsupported format: {format}")
        self.logger.info(f"Report saved to {output_file} in {format.upper()} format")

def main():
    parser = argparse.ArgumentParser(description='Email Phishing Analyzer')
    parser.add_argument('eml_files', nargs='+', type=Path, help='EML files to analyze')
    parser.add_argument('-f', '--format', choices=['json', 'csv'], default='json',
                        help='Output format (default: json)')
    parser.add_argument('-o', '--output', type=Path, default=Path('phishing_report.json'),
                        help='Output file path')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose logging')
    parser.add_argument('-q', '--quiet', action='store_true', help='Quiet mode')

    args = parser.parse_args()

    log_level = 'DEBUG' if args.verbose else 'WARNING' if args.quiet else 'INFO'
    analyzer = PhishingAnalyzer(log_level)

    results = []
    for eml_file in args.eml_files:
        if eml_file.exists():
            result = analyzer.analyze_email(eml_file)
            if result:
                results.append(result)
        else:
            analyzer.logger.error(f"File not found: {eml_file}")

    if results:
        analyzer.save_report(results, args.output, args.format)
        print(f"Analysis complete. Processed {len(results)} emails.")
        print(f"Report saved to {args.output} in {args.format.upper()} format")
    else:
        print("No emails processed successfully.")

if __name__ == "__main__":
    main()