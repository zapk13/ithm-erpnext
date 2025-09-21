# ITHM ERPNext Education Management System

A centralized management system for the Institute of Tourism and Hospitality Management (ITHM) built on ERPNext.

## Features

- **Student Management**: Complete student records, admissions, and academic tracking
- **Fee Management**: Fee structure, collection, and payment tracking
- **Admission Applications**: Online admission forms for students
- **Multi-Campus Support**: Manage main campus and sub-campuses
- **Staff Management**: Add and manage staff for all campuses
- **Central Dashboard**: Management insights and analytics
- **Course Management**: Add and manage courses and programs
- **Fee Structure**: Flexible fee management system

## Quick Start

### Using Docker (Recommended for GitHub Codespaces)

1. Clone the repository:
   ```bash
   git clone https://github.com/zapk13/ithm-erpnext.git
   cd ithm-erpnext
   ```

2. Start the services:
   ```bash
   docker-compose up -d
   ```

3. Access ERPNext:
   - URL: http://localhost:8000
   - Username: Administrator
   - Password: admin

### Manual Installation

Run the installation script:
```bash
chmod +x install_erpnext.sh
./install_erpnext.sh
```

## Configuration for ITHM

After installation, configure the system for ITHM:

1. **Company Setup**: Set up Institute of Tourism and Hospitality Management as the main company
2. **Campus Management**: Add main campus and sub-campuses
3. **Programs**: Add tourism and hospitality programs
4. **Fee Structure**: Configure fee structure for different programs
5. **User Roles**: Set up roles for different staff levels

## Management Dashboard

The central dashboard provides:
- Student enrollment statistics
- Fee collection reports
- Admission application status
- Staff performance metrics
- Campus-wise analytics

## Support

For technical support or questions, contact the IT department.

## License

This project is licensed under the MIT License.
