# ITHM ERPNext Education Management System

Configuration files and documentation for the Institute of Tourism and Hospitality Management (ITHM) ERPNext setup.

## Overview

This repository contains all the configuration files needed to set up ERPNext for ITHM's education management system. It includes:

- **Configuration Files**: Ready-to-use JSON configurations for ERPNext
- **User Roles**: Predefined roles for different staff levels
- **Program Structure**: Tourism and hospitality programs
- **Fee Structure**: PKR-based fee management
- **Campus Setup**: Multi-campus configuration

## Features

- **Student Management**: Complete student records, admissions, and academic tracking
- **Fee Management**: PKR-based fee structure and payment tracking
- **Admission Applications**: Online admission forms for students
- **Multi-Campus Support**: Karachi (main), Lahore, and Islamabad campuses
- **Staff Management**: Role-based access control
- **Central Dashboard**: Management insights and analytics
- **Program Management**: Tourism and hospitality programs

## Quick Setup

### Option 1: Complete Automated Setup (Recommended)

**For Linux/Ubuntu:**
```bash
chmod +x auto-setup.sh
./auto-setup.sh
```

**For Windows:**
```cmd
auto-setup.bat
```

**For GitHub Codespaces:**
```bash
chmod +x codespace-setup.sh
./codespace-setup.sh
```

### Option 2: Manual Setup

1. **Install ERPNext** (separate installation):
   ```bash
   pip3 install frappe-bench
   bench init frappe-bench
   cd frappe-bench
   bench new-site ithm.local --admin-password admin
   bench --site ithm.local install-app erpnext
   bench --site ithm.local install-app education
   ```

2. **Configure using this repository**:
   - Use `ithm-config.json` for company setup
   - Use `user-roles.json` for role configuration
   - Use `programs.json` for academic programs
   - Use `fee-structure.json` for fee management

3. **Start ERPNext**:
   ```bash
   bench start
   ```

4. **Access**: http://ithm.local:8000 (admin/admin)

## Automated Setup Features

The automated setup scripts handle everything:

✅ **Prerequisites Installation**:
- Python 3, Node.js, MariaDB, Redis
- All required system packages
- Development tools and dependencies

✅ **ERPNext Installation**:
- Frappe Bench installation
- ERPNext core application
- Education module installation
- Site creation and configuration

✅ **ITHM Configuration**:
- Company setup for ITHM
- PKR currency configuration
- Campus setup (Karachi, Lahore, Islamabad)
- User roles and permissions
- Academic programs structure
- Fee management system

✅ **Service Management**:
- Systemd service (Linux) / Windows service
- Auto-start on boot
- Management commands
- Log monitoring

## Configuration Files

- `ithm-config.json` - Main ITHM configuration
- `erpnext-config.json` - ERPNext site configuration
- `user-roles.json` - User roles and permissions
- `programs.json` - Academic programs structure
- `fee-structure.json` - Fee management configuration

## Management Features

- **Multi-Campus**: Karachi (main), Lahore, Islamabad
- **Programs**: Tourism, Hospitality, Event Management, Culinary Arts
- **Currency**: PKR (Pakistani Rupee)
- **Roles**: Director, Campus Head, Academic Coordinator, etc.
- **Fee Types**: Tuition, Admission, Hostel, Transport, etc.

## Support

This repository contains only configuration files. For ERPNext installation support, refer to the official ERPNext documentation.
