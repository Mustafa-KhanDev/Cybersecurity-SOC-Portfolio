import unittest
from pathlib import Path
from phishing_analyzer import PhishingAnalyzer

class TestPhishingAnalyzer(unittest.TestCase):
    def setUp(self):
        self.analyzer = PhishingAnalyzer('WARNING')  # Reduce log noise

    def test_extract_sender_ip(self):
        # Mock message with Received header
        class MockMsg:
            def get_all(self, header):
                return ["from mail.example.com (mail.example.com [192.168.1.100])"]

        msg = MockMsg()
        ip = self.analyzer.extract_sender_ip(msg)
        self.assertEqual(ip, "192.168.1.100")

    def test_extract_urls_and_hashes(self):
        text = "Check this link: http://example.com and hash: d41d8cd98f00b204e9800998ecf8427e"
        urls, hashes = self.analyzer.extract_urls_and_hashes(text)
        self.assertIn("http://example.com", urls)
        self.assertIn("d41d8cd98f00b204e9800998ecf8427e", hashes)

    def test_extract_subject(self):
        class MockMsg:
            def get(self, header, default=None):
                return "Test Subject" if header == 'Subject' else default

        msg = MockMsg()
        subject = self.analyzer.extract_subject(msg)
        self.assertEqual(subject, "Test Subject")

if __name__ == '__main__':
    unittest.main()