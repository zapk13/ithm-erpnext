# ITHM ERPNext Setup Guide

## Quick Setup for Institute of Tourism and Hospitality Management

### Prerequisites
- Python 3.8+
- Node.js 14+
- MariaDB/MySQL
- Redis

### Installation Steps

1. **Install ERPNext using bench** (one-time setup):
   ```bash
   pip3 install frappe-bench
   bench init frappe-bench
   cd frappe-bench
   bench new-site ithm.local --admin-password admin
   bench --site ithm.local install-app erpnext
   bench --site ithm.local install-app education
   ```

2. **Start the server**:
   ```bash
   bench start
   ```

3. **Access ERPNext**:
   - URL: http://ithm.local:8000
   - Username: Administrator
   - Password: admin

### Configuration for ITHM

After installation, use the configuration files in this repository:

1. **Company Setup**: Use `ithm-config.json` for company details
2. **Campus Management**: Configure campuses as per the config
3. **Programs**: Set up tourism and hospitality programs
4. **User Roles**: Configure roles for different staff levels

### Management Features

- **Student Management**: Complete student records and admissions
- **Fee Management**: PKR-based fee structure
- **Multi-Campus**: Karachi (main), Lahore, Islamabad
- **Staff Management**: Role-based access control
- **Dashboard**: Central management insights

### Support

This repository contains only configuration files and documentation. The actual ERPNext installation is done separately using the official bench installer.
