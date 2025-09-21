#!/bin/bash

set -e  # Exit on any error

# Start ERPNext services
echo "Starting ERPNext services..."

# Wait for database to be ready
echo "Waiting for database connection..."
until mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    echo "Waiting for database..."
    sleep 2
done
echo "Database is ready!"

# Start supervisor
echo "Starting supervisor..."
supervisord -c /home/frappe/frappe-bench/config/supervisor.conf

# Wait for services to start
sleep 10

# Check if site exists, if not create it
if [ ! -d "/home/frappe/frappe-bench/sites/ithm.local" ]; then
    echo "Creating new site: ithm.local"
    bench new-site ithm.local --admin-password admin123 --mariadb-root-password admin123 --db-name erpnext
else
    echo "Site ithm.local already exists"
fi

# Install ERPNext if not already installed
if [ ! -d "/home/frappe/frappe-bench/apps/erpnext" ]; then
    echo "Installing ERPNext..."
    bench get-app erpnext
    bench install-app erpnext
else
    echo "ERPNext already installed"
fi

# Start the bench
echo "Starting bench..."
bench start

