#!/bin/bash

# Start ERPNext services
echo "Starting ERPNext services..."

# Start supervisor
supervisord -c /home/frappe/frappe-bench/config/supervisor.conf

# Wait for services to start
sleep 10

# Check if site exists, if not create it
if [ ! -d "/home/frappe/frappe-bench/sites/ithm.local" ]; then
    echo "Creating new site: ithm.local"
    bench new-site ithm.local --admin-password admin123 --mariadb-root-password admin123 --db-name erpnext
fi

# Install ERPNext if not already installed
if [ ! -d "/home/frappe/frappe-bench/apps/erpnext" ]; then
    echo "Installing ERPNext..."
    bench get-app erpnext
    bench install-app erpnext
fi

# Start the bench
echo "Starting bench..."
bench start

