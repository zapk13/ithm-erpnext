#!/bin/bash

# ITHM ERPNext Complete Automated Setup
# This script installs everything from scratch for Institute of Tourism and Hospitality Management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

echo "🚀 ITHM ERPNext Complete Automated Setup"
echo "========================================"
echo "Institute of Tourism and Hospitality Management"
echo ""

# Update system
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install all prerequisites
print_status "Installing prerequisites..."
sudo apt install -y \
    software-properties-common \
    cron \
    curl \
    wget \
    git \
    build-essential \
    python3-dev \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    redis-server \
    mariadb-server \
    mariadb-client \
    nginx \
    supervisor

# Add Python 3.11 repository
print_status "Adding Python 3.11 repository..."
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

# Install Python 3.11
print_status "Installing Python 3.11..."
sudo apt install -y python3.11 python3.11-venv python3.11-dev

# Start services
print_status "Starting services..."
sudo service redis-server start
sudo service mariadb start

# Configure MariaDB
print_status "Configuring MariaDB..."
sudo mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('12345');"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE IF EXISTS test;"
sudo mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create database and user for Frappe
print_status "Creating database and user..."
sudo mysql -u root -p12345 -e "CREATE DATABASE IF NOT EXISTS ithm_erpnext;"
sudo mysql -u root -p12345 -e "CREATE USER IF NOT EXISTS 'frappe'@'localhost' IDENTIFIED BY 'admin';"
sudo mysql -u root -p12345 -e "GRANT ALL PRIVILEGES ON ithm_erpnext.* TO 'frappe'@'localhost';"
sudo mysql -u root -p12345 -e "FLUSH PRIVILEGES;"

# Install Frappe Bench
print_status "Installing Frappe Bench..."
python3.11 -m pip install frappe-bench

# Create frappe user
print_status "Creating frappe user..."
sudo adduser frappe --disabled-password --gecos "" || true
sudo usermod -aG sudo frappe || true

# Install ERPNext as frappe user
print_status "Installing ERPNext..."
sudo -u frappe bash << 'EOF'
cd /home/frappe
python3.11 -m pip install frappe-bench
bench init frappe-bench --frappe-branch version-14 --python python3.11
cd frappe-bench
bench new-site ithm.local --admin-password admin --db-root-password 12345 --db-name ithm_erpnext --db-password admin
bench --site ithm.local install-app erpnext
bench --site ithm.local install-app education
bench config set-common-config -c developer_mode 1
bench config set-common-config -c file_watch 1
EOF

# Create ITHM configuration
print_status "Creating ITHM configuration..."
sudo -u frappe bash << 'EOF'
cd /home/frappe/frappe-bench
bench --site ithm.local set-config company_name "Institute of Tourism and Hospitality Management"
bench --site ithm.local set-config company_abbr "ITHM"
bench --site ithm.local set-config default_currency "PKR"
bench --site ithm.local set-config country "Pakistan"
bench --site ithm.local set-config timezone "Asia/Karachi"
EOF

# Create startup script
print_status "Creating startup script..."
sudo tee /home/frappe/start-ithm.sh > /dev/null << 'EOF'
#!/bin/bash
cd /home/frappe/frappe-bench
bench start
EOF

sudo chmod +x /home/frappe/start-ithm.sh
sudo chown frappe:frappe /home/frappe/start-ithm.sh

# Create management script
print_status "Creating management script..."
sudo tee /usr/local/bin/ithm-manage > /dev/null << 'EOF'
#!/bin/bash
case "$1" in
    start)
        sudo -u frappe bash -c "cd /home/frappe/frappe-bench && bench start" &
        echo "ITHM ERPNext started"
        ;;
    stop)
        sudo pkill -f "bench start"
        echo "ITHM ERPNext stopped"
        ;;
    restart)
        sudo pkill -f "bench start"
        sleep 2
        sudo -u frappe bash -c "cd /home/frappe/frappe-bench && bench start" &
        echo "ITHM ERPNext restarted"
        ;;
    status)
        if pgrep -f "bench start" > /dev/null; then
            echo "ITHM ERPNext is running"
        else
            echo "ITHM ERPNext is not running"
        fi
        ;;
    logs)
        sudo -u frappe bash -c "cd /home/frappe/frappe-bench && bench --site ithm.local logs"
        ;;
    *)
        echo "Usage: ithm-manage {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
EOF

sudo chmod +x /usr/local/bin/ithm-manage

# Start ERPNext
print_status "Starting ERPNext..."
sudo -u frappe bash -c "cd /home/frappe/frappe-bench && bench start" &

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Display final information
echo ""
echo "========================================"
print_success "ITHM ERPNext Setup Complete!"
echo "========================================"
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
echo "🎯 ITHM Configuration:"
echo "   Company: Institute of Tourism and Hospitality Management"
echo "   Currency: PKR (Pakistani Rupee)"
echo "   Country: Pakistan"
echo "   Timezone: Asia/Karachi"
echo ""
print_success "Setup completed successfully! 🎉"
