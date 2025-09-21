#!/bin/bash

# GitHub Codespaces Setup Script for ITHM ERPNext
echo "Setting up ITHM ERPNext in GitHub Codespaces..."

# Update system
sudo apt update

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Start the ERPNext services
echo "Starting ERPNext services..."
docker-compose up -d

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 30

# Check if services are running
echo "Checking service status..."
docker-compose ps

echo ""
echo "🎉 Setup Complete!"
echo "Access your ERPNext instance at: http://localhost:8000"
echo "Username: Administrator"
echo "Password: admin"
echo ""
echo "To stop services: docker-compose down"
echo "To view logs: docker-compose logs -f"
