#!/bin/bash

# Quick fix for database already exists error
echo "🔧 Fixing database issue..."

# Drop existing database
sudo mysql -u root -p12345 -e "DROP DATABASE IF EXISTS ithm_erpnext;"

# Create fresh database
sudo mysql -u root -p12345 -e "CREATE DATABASE ithm_erpnext;"
sudo mysql -u root -p12345 -e "GRANT ALL PRIVILEGES ON ithm_erpnext.* TO 'frappe'@'localhost';"
sudo mysql -u root -p12345 -e "FLUSH PRIVILEGES;"

# Remove existing frappe-bench
rm -rf frappe-bench

# Reinstall
python3.11 -m pip install frappe-bench
bench init frappe-bench --frappe-branch version-14 --python python3.11
cd frappe-bench
bench new-site ithm.local --admin-password admin --db-root-password 12345 --db-name ithm_erpnext --db-password admin
bench --site ithm.local install-app erpnext
bench --site ithm.local install-app education
bench config set-common-config -c developer_mode 1
bench config set-common-config -c file_watch 1

# Start
bench start

echo "✅ Fixed! Access at http://localhost:8000 (admin/admin)"
