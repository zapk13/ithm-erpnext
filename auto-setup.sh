#!/bin/bash

# ITHM ERPNext Complete Automated Setup Script
# This script installs everything needed for ITHM education management system

set -e  # Exit on any error

echo "🚀 Starting ITHM ERPNext Complete Setup..."
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root. Run as a regular user."
    exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install prerequisites
print_status "Installing prerequisites..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    python3-setuptools \
    python3-wheel \
    curl \
    wget \
    git \
    redis-server \
    mariadb-server \
    mariadb-client \
    nginx \
    supervisor \
    cron \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Node.js 18.x
print_status "Installing Node.js 18.x..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn
print_status "Installing Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Configure MariaDB
print_status "Configuring MariaDB..."
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Set MariaDB root password
sudo mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('admin');"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Start Redis
print_status "Starting Redis..."
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Create frappe user
print_status "Creating frappe user..."
if ! id "frappe" &>/dev/null; then
    sudo adduser frappe --disabled-password --gecos ""
    sudo usermod -aG sudo frappe
    print_success "Frappe user created"
else
    print_warning "Frappe user already exists"
fi

# Install bench
print_status "Installing Frappe Bench..."
sudo pip3 install frappe-bench

# Switch to frappe user and install ERPNext
print_status "Installing ERPNext as frappe user..."
sudo -u frappe bash << 'EOF'
cd /home/frappe

# Initialize frappe-bench
bench init frappe-bench --frappe-branch version-14 --python python3

# Navigate to frappe-bench directory
cd frappe-bench

# Create new site
bench new-site ithm.local --admin-password admin --db-root-password admin

# Install ERPNext
bench --site ithm.local install-app erpnext

# Install Education module
bench --site ithm.local install-app education

# Set up production configuration
bench config set-common-config -c developer_mode 1
bench config set-common-config -c file_watch 1

# Create production setup
bench setup production frappe

# Set up nginx
bench setup nginx

# Set up supervisor
bench setup supervisor

# Start all services
bench start
EOF

# Configure ITHM specific settings
print_status "Configuring ITHM specific settings..."

# Copy configuration files to frappe directory
sudo cp ithm-config.json /home/frappe/frappe-bench/sites/ithm.local/
sudo cp erpnext-config.json /home/frappe/frappe-bench/sites/ithm.local/
sudo cp user-roles.json /home/frappe/frappe-bench/sites/ithm.local/
sudo cp programs.json /home/frappe/frappe-bench/sites/ithm.local/
sudo cp fee-structure.json /home/frappe/frappe-bench/sites/ithm.local/

# Set proper permissions
sudo chown -R frappe:frappe /home/frappe/frappe-bench/sites/ithm.local/

# Create startup script
print_status "Creating startup script..."
sudo tee /home/frappe/start-ithm.sh > /dev/null << 'EOF'
#!/bin/bash
cd /home/frappe/frappe-bench
bench start
EOF

sudo chmod +x /home/frappe/start-ithm.sh
sudo chown frappe:frappe /home/frappe/start-ithm.sh

# Create systemd service for auto-start
print_status "Creating systemd service..."
sudo tee /etc/systemd/system/ithm-erpnext.service > /dev/null << 'EOF'
[Unit]
Description=ITHM ERPNext Service
After=network.target mariadb.service redis.service

[Service]
Type=simple
User=frappe
WorkingDirectory=/home/frappe/frappe-bench
ExecStart=/home/frappe/start-ithm.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable ithm-erpnext.service

# Create management script
print_status "Creating management script..."
sudo tee /usr/local/bin/ithm-manage > /dev/null << 'EOF'
#!/bin/bash
case "$1" in
    start)
        sudo systemctl start ithm-erpnext
        echo "ITHM ERPNext started"
        ;;
    stop)
        sudo systemctl stop ithm-erpnext
        echo "ITHM ERPNext stopped"
        ;;
    restart)
        sudo systemctl restart ithm-erpnext
        echo "ITHM ERPNext restarted"
        ;;
    status)
        sudo systemctl status ithm-erpnext
        ;;
    logs)
        sudo journalctl -u ithm-erpnext -f
        ;;
    *)
        echo "Usage: ithm-manage {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
EOF

sudo chmod +x /usr/local/bin/ithm-manage

# Final setup
print_status "Finalizing setup..."

# Start the service
sudo systemctl start ithm-erpnext

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Check if services are running
if systemctl is-active --quiet ithm-erpnext; then
    print_success "ITHM ERPNext service is running!"
else
    print_warning "Service might still be starting. Check status with: ithm-manage status"
fi

# Display final information
echo ""
echo "=============================================="
print_success "ITHM ERPNext Setup Complete!"
echo "=============================================="
echo ""
echo "🌐 Access Information:"
echo "   URL: http://localhost:8000"
echo "   Username: Administrator"
echo "   Password: admin"
echo ""
echo "📁 Installation Directory:"
echo "   /home/frappe/frappe-bench/"
echo ""
echo "🔧 Management Commands:"
echo "   Start:   ithm-manage start"
echo "   Stop:    ithm-manage stop"
echo "   Restart: ithm-manage restart"
echo "   Status:  ithm-manage status"
echo "   Logs:    ithm-manage logs"
echo ""
echo "📋 Configuration Files:"
echo "   All ITHM config files are in: /home/frappe/frappe-bench/sites/ithm.local/"
echo ""
echo "🎯 Next Steps:"
echo "   1. Access ERPNext at http://localhost:8000"
echo "   2. Configure company details using ithm-config.json"
echo "   3. Set up user roles using user-roles.json"
echo "   4. Configure programs using programs.json"
echo "   5. Set up fee structure using fee-structure.json"
echo ""
print_success "Setup completed successfully! 🎉"
