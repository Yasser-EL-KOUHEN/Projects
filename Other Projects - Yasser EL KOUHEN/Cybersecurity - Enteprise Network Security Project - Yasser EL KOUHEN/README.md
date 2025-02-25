# Enterprise Network Security

## Overview
This project focuses on conducting penetration testing on a vulnerable machine within a controlled environment. It follows a structured approach covering the key phases of a penetration test: reconnaissance, network scanning, enumeration, and gaining access. The goal is to identify security vulnerabilities and propose mitigations to improve the overall security posture.

The work is documented in a detailed **Enterprise Network Security Report**, which describes the methodology, tools, and results obtained from the penetration test.

## Features
- **Reconnaissance / Footprint**: Collecting information about the target using OSINT techniques.
- **Scanning Networks**: Identifying active hosts, open ports, and services.
- **Enumeration**: Extracting system details such as OS versions, running services, and user accounts.
- **Gaining Access**: Exploiting vulnerabilities to gain unauthorized access.
- **Security Recommendations**: Providing mitigation strategies to patch vulnerabilities.

## Tools Implemented
The following tools were used at different stages of the penetration test:

### **Reconnaissance / Footprint**
- **WHOIS**: Queries domain registration information.
- **DNS Lookup**: Retrieves DNS records of a target.

### **Scanning Networks**
- **Ping**: Checks if a host is online.
- **Traceroute**: Identifies the path packets take to reach a target.
- **Netcat**: Scans for open ports.
- **Nmap**: Conducts detailed service and vulnerability scans.

### **Enumeration**
- **Banner Grabbing (Telnet, Nmap -sV)**: Extracts service information.
- **OS Enumeration (Nmap -O)**: Determines the target OS.
- **User Enumeration (Enum4Linux, Nbtscan)**: Lists user accounts and NetBIOS details.

### **Gaining Access**
- **FTP Exploitation (Telnet, Hydra, Metasploit)**: Attempts to access FTP services.
- **SSH Exploitation (Hydra, Metasploit)**: Brute-forces SSH credentials.

## Installation
To set up the penetration testing environment, follow these steps:

### **1. Create the Working Environment**
```bash
mkdir ~/srie
mkdir ~/srie/pyenvs
mkdir ~/srie/repos
python3 -m venv ~/srie/pyenvs/pyflasql
```
## Contents
### 📄 **Documentation**
- [Enterprise Network Security Report](./Enterprise%20Network%20Security%20Report%20-%20Yasser%20EL%20KOUHEN.pdf): Detailed analysis of the penetration test, including methodologies, results, and security recommendations.

### 🔧 **Framework & Tools**
- The PyFlaSQL framework is used for executing penetration testing tasks.
- Implementation of various security tools for reconnaissance, scanning, enumeration, and exploitation.

### 🚀 **Setup & Installation**
- Follow the step-by-step [Installation Guide](#installation) to set up the environment and run the framework.
