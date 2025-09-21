#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting ERPNext Education Portal..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
until mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    echo "Waiting for database..."
    sleep 2
done
echo "✅ Database is ready!"

# Initialize bench if not already done
if [ ! -d "/home/frappe/frappe-bench" ]; then
    echo "🏗️ Initializing bench..."
    bench init frappe-bench --frappe-branch version-14
    cd /home/frappe/frappe-bench
fi

# Check if site exists, if not create it
if [ ! -d "/home/frappe/frappe-bench/sites/ithm.local" ]; then
    echo "🏗️ Creating new site: ithm.local"
    bench new-site ithm.local --admin-password admin123 --mariadb-root-password admin123 --db-name erpnext
else
    echo "✅ Site ithm.local already exists"
fi

# Install ERPNext if not already installed
if [ ! -d "/home/frappe/frappe-bench/apps/erpnext" ]; then
    echo "📦 Installing ERPNext..."
    bench get-app erpnext
    bench install-app erpnext
else
    echo "✅ ERPNext already installed"
fi

# Start the bench directly (no supervisor)
echo "🎯 Starting ERPNext services..."
bench start --skip-redis-config-generation

echo "🎉 ERPNext Education Portal is ready!"
echo "🌐 Access at: http://localhost:8000"
echo "👤 Login: Administrator / admin123"

