# ERPNext Education Portal - Institute of Tourism and Hospitality Management

A comprehensive education management system built on ERPNext specifically configured for the **Institute of Tourism and Hospitality Management (ITHM)**. This portal provides complete student lifecycle management, course administration, and academic operations.

## 🏫 Features

### Academic Management
- **Student Information System**: Complete student profiles, enrollment, and academic records
- **Course Management**: Tourism and hospitality-focused curriculum management
- **Program Administration**: Degree and certificate program tracking
- **Academic Calendar**: Semester planning and scheduling
- **Grade Management**: Assessment tracking and report cards
- **Attendance Management**: Digital attendance with analytics

### Tourism & Hospitality Specific Modules
- **Internship Management**: Industry placement tracking
- **Practical Training**: Hands-on skills assessment
- **Industry Partnerships**: Company collaboration management
- **Event Management**: Educational events and workshops
- **Resource Management**: Equipment and facility booking

### Administrative Features
- **Fee Management**: Tuition and payment tracking
- **Library Management**: Academic resource management
- **Hostel Management**: Accommodation administration
- **Transport Management**: Student transportation
- **Communication**: Automated notifications and announcements

## 🚀 Quick Start with GitHub Codespaces

### Option 1: One-Click Setup
1. Click the "Code" button on this repository
2. Select "Codespaces" tab
3. Click "Create codespace on main"
4. Wait for the automatic setup to complete (5-10 minutes)
5. Access the portal at `http://localhost:8000`

### Option 2: Manual Setup
```bash
# Clone the repository
git clone <repository-url>
cd erpnext-ithm-education-portal

# Start with Docker Compose
docker-compose up -d

# Access the portal
open http://localhost:8000
```

## 🔑 Default Login Credentials

- **URL**: `http://localhost:8000`
- **Username**: `Administrator`
- **Password**: `admin123`
- **Site**: `ithm.local`

## 📚 Pre-configured Academic Data

The system comes pre-loaded with:

### Programs
- Bachelor of Tourism Management (BTM)
- Bachelor of Hospitality Management (BHM)
- Master of Tourism and Hospitality (MTH)
- Diploma in Hotel Management (DHM)
- Certificate in Culinary Arts (CCA)

### Sample Courses
- Tourism Geography (TG101)
- Hospitality Operations (HO201)
- Event Management (EM301)
- Culinary Skills (CS401)
- Hotel Internship (HI501)

### Faculty
- Dr. Sarah Johnson (Tourism Studies)
- Prof. Michael Chen (Hospitality Management)
- Chef Maria Rodriguez (Culinary Arts)

### Course Categories
- Core Courses
- Elective Courses
- Practical Training
- Industry Exposure

## 🛠️ Development Environment

This setup includes:
- **ERPNext v14**: Latest stable version
- **Education App**: Complete academic management
- **MariaDB 10.6**: Optimized database
- **Redis**: Caching and queues
- **Nginx**: Reverse proxy and static files
- **Python Environment**: Fully configured development environment

## 📁 Project Structure

```
erpnext-ithm-education-portal/
├── .devcontainer/
│   ├── devcontainer.json      # Codespaces configuration
│   └── setup.sh              # Automated setup script
├── nginx/
│   └── conf.d/
│       └── default.conf       # Nginx configuration
├── sites/
│   ├── common_site_config.json # ERPNext site configuration
│   └── ithm.local/            # Site-specific files
├── docker-compose.yml         # Multi-container setup
├── Dockerfile                 # ERPNext container
└── README.md                  # This file
```

## 🔧 Configuration

### Database Settings
- **Host**: `db` (MariaDB 10.6)
- **Database**: `erpnext`
- **Username**: `erpnext`
- **Password**: `erpnext123`

### Redis Services
- **Cache**: `redis://redis-cache:6379`
- **Queue**: `redis://redis-queue:6379`
- **Socket.IO**: `redis://redis-socketio:6379`

### Ports
- **Web Interface**: `8000`
- **Socket.IO**: `9000`
- **Database**: `3306`
- **Nginx**: `80`

## 📖 Usage Guide

### Getting Started
1. **Access the System**: Navigate to `http://localhost:8000`
2. **Login**: Use the Administrator credentials
3. **Setup Wizard**: Complete the initial setup if prompted
4. **Explore Modules**: Navigate through Education, Student, and Academic modules

### Key Workflows
1. **Student Enrollment**:
   - Go to Student → New Student
   - Fill in personal and academic details
   - Assign to program and academic year

2. **Course Creation**:
   - Go to Education → Course
   - Create courses with codes and categories
   - Assign instructors and schedules

3. **Program Management**:
   - Set up degree programs and requirements
   - Create course structures and prerequisites
   - Manage academic calendars

4. **Assessment Management**:
   - Create assessment criteria and grading scales
   - Record student grades and generate reports
   - Track academic progress

## 🔍 Troubleshooting

### Common Issues
1. **Database Connection Error**: Wait for all services to start (check with `docker-compose ps`)
2. **Port Conflicts**: Ensure ports 8000, 9000, 3306, 80 are available
3. **Slow Performance**: Allocate more resources to your Codespace

### Logs
```bash
# View application logs
docker-compose logs erpnext

# View database logs  
docker-compose logs db

# View all services
docker-compose logs
```

### Reset Setup
```bash
# Stop and remove containers
docker-compose down -v

# Rebuild and restart
docker-compose up -d --build
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- **ERPNext Documentation**: https://docs.erpnext.com
- **Education Module Guide**: https://docs.erpnext.com/education
- **Community Forum**: https://discuss.erpnext.com
- **GitHub Issues**: For bug reports and feature requests

## 🎓 About Institute of Tourism and Hospitality Management

This configuration is specifically tailored for tourism and hospitality education, including:
- Industry-relevant course structures
- Practical training management
- Internship and placement tracking
- Industry partnership management
- Event and workshop coordination

Perfect for educational institutions focusing on tourism, hospitality, hotel management, and culinary arts education.

---

**Ready to transform tourism and hospitality education with ERPNext! 🌟**