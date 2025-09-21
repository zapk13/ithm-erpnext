#!/bin/bash

# GitHub Codespaces One-Command Setup for ITHM ERPNext
# This script sets up everything in a Codespace environment

set -e

echo "🚀 Setting up ITHM ERPNext in GitHub Codespaces..."

# Update system
sudo apt update

# Install prerequisites
sudo apt install -y python3 python3-pip python3-venv nodejs npm redis-server mariadb-server

# Start services
sudo systemctl start redis-server mariadb

# Install bench
pip3 install frappe-bench

# Create frappe user
sudo adduser frappe --disabled-password --gecos ""
sudo usermod -aG sudo frappe

# Install ERPNext as frappe user
sudo -u frappe bash << 'EOF'
cd /home/frappe
bench init frappe-bench --frappe-branch version-14
cd frappe-bench
bench new-site ithm.local --admin-password admin --db-root-password admin
bench --site ithm.local install-app erpnext
bench --site ithm.local install-app education
bench start
EOF

echo "✅ Setup complete! Access at http://localhost:8000 (admin/admin)"
