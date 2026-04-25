#!/bin/bash
# Portfolio Demo Script
# Runs all tests and demonstrates functionality

echo "=========================================="
echo "Cybersecurity SOC Portfolio Demo"
echo "=========================================="
echo

# Project 1: Validate Splunk configs
echo "Project 1: SIEM Pipeline"
echo "-----------------------"
cd Project1_Logging_Monitoring_Pipeline/tests
powershell.exe -ExecutionPolicy Bypass -File validate_configs.ps1
cd ../..
echo

# Project 2: Show detection query
echo "Project 2: Brute Force Detection"
echo "-------------------------------"
echo "SPL Query:"
cat Project2_Failed_Login_Monitor_Alerting/src/brute_force_detection.spl
echo

# Project 3: Run Python tests
echo "Project 3: Email Phishing Analyzer"
echo "----------------------------------"
cd Project3_Email_Phishing_Reporting_Script
python -m pytest tests/ -v
cd ..
echo

# Project 4: Run PowerShell tests
echo "Project 4: Process Detector"
echo "---------------------------"
cd Project4_Suspicious_Process_Detector/tests
powershell.exe -ExecutionPolicy Bypass -File test_suspicious_processes.ps1
cd ../..
echo

# Project 5: Validate Azure roles
echo "Project 5: Azure IAM Policies"
echo "----------------------------"
cd Project5_Cloud_Least_Privilege_IAM_Policy/tests
powershell.exe -ExecutionPolicy Bypass -File validate_roles.ps1
cd ../..
echo

echo "=========================================="
echo "Demo Complete!"
echo "Check individual project READMEs for full usage."
echo "=========================================="