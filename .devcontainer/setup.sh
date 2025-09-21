#!/bin/bash

echo "🚀 Setting up ERPNext Education Portal in Codespaces..."

# Start all services using docker-compose
echo "🐳 Starting all services (database, Redis, and ERPNext)..."
cd /workspaces/ithm-erpnext
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 60

# Check if ERPNext container is running
echo "🔍 Checking ERPNext container status..."
docker-compose ps

echo "🎉 ERPNext Education Portal is ready!"
echo "🌐 Access at: http://localhost:8000"
echo "👤 Login: Administrator / admin123"
echo ""
echo "💡 If ERPNext is not accessible, try:"
echo "   docker-compose logs erpnext"
echo "   docker-compose restart erpnext"
