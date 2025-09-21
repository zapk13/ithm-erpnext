#!/bin/bash

echo "🚀 Setting up ERPNext Education Portal in Codespaces..."

# Start services using docker-compose
echo "🐳 Starting database and Redis services..."
cd /workspaces/ithm-erpnext
docker-compose up -d db redis-cache redis-queue redis-socketio

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
sleep 30

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

# Start the bench
echo "🎯 Starting ERPNext services..."
bench start --skip-redis-config-generation

echo "🎉 ERPNext Education Portal is ready!"
echo "🌐 Access at: http://localhost:8000"
echo "👤 Login: Administrator / admin123"
