#!/bin/bash

# ERPNext Installation Script for Institute of Tourism and Hospitality Management
# This script sets up ERPNext with education module for ITHM

echo "Setting up ERPNext for Institute of Tourism and Hospitality Management..."

# Update system packages
sudo apt update

# Install Python and required packages
sudo apt install -y python3 python3-pip python3-dev python3-venv

# Install Node.js (required for ERPNext)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install other dependencies
sudo apt install -y git curl redis-server

# Install MariaDB
sudo apt install -y mariadb-server mariadb-client

# Start and enable services
sudo systemctl start redis-server
sudo systemctl enable redis-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Install bench (ERPNext installer)
sudo pip3 install frappe-bench

# Create frappe user
sudo adduser frappe --disabled-password --gecos ""
sudo usermod -aG sudo frappe

# Switch to frappe user and install ERPNext
sudo -u frappe bash << 'EOF'
cd /home/frappe
bench init frappe-bench --frappe-branch version-14
cd frappe-bench
bench new-site ithm.local --admin-password admin --db-root-password admin
bench --site ithm.local install-app erpnext
bench --site ithm.local install-app education

# Start the development server
bench start
EOF

echo "ERPNext installation completed!"
echo "Access your ERPNext instance at: http://ithm.local:8000"
echo "Username: Administrator"
echo "Password: admin"
