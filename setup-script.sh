#!/bin/bash

# Setup script for ERPNext Education Portal - ITHM
echo "🏫 Setting up ERPNext Education Portal for Institute of Tourism and Hospitality Management..."

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
while ! nc -z db 3306; do
  sleep 1
done
echo "✅ Database is ready!"

# Navigate to bench directory
cd /home/frappe/frappe-bench

# Create new site if it doesn't exist
if [ ! -d "sites/ithm.local" ]; then
  echo "🏗️ Creating new site: ithm.local"
  bench new-site ithm.local \
    --mariadb-root-password admin123 \
    --admin-password admin123 \
    --verbose
else
  echo "✅ Site ithm.local already exists"
fi

# Install Education app if not already installed
echo "📚 Installing Education app..."
if [ ! -d "apps/education" ]; then
  bench get-app education
fi

# Install education app on site
bench --site ithm.local install-app education

# Install ERPNext if not already installed
echo "💼 Installing ERPNext..."
bench --site ithm.local install-app erpnext

# Set developer mode
bench --site ithm.local set-config developer_mode 1

# Create initial setup for ITHM
echo "🎓 Setting up Institute of Tourism and Hospitality Management configuration..."

# Enable scheduler
bench --site ithm.local enable-scheduler

# Set site config
bench --site ithm.local set-config mute_emails 1
bench --site ithm.local set-config disable_website_cache 1

# Migrate
bench --site ithm.local migrate

# Build assets
bench build --app frappe --app erpnext --app education

# Create initial company and academic setup via Python script
cat > /tmp/setup_ithm.py << 'EOF'
import frappe

def setup_ithm():
    frappe.connect(site='ithm.local')
    
    # Create Company
    if not frappe.db.exists("Company", "Institute of Tourism and Hospitality Management"):
        company = frappe.get_doc({
            "doctype": "Company",
            "company_name": "Institute of Tourism and Hospitality Management",
            "abbr": "ITHM",
            "default_currency": "USD",
            "country": "United States"
        })
        company.insert()
        frappe.db.commit()
        print("✅ Company created: Institute of Tourism and Hospitality Management")
    
    # Create Academic Year
    if not frappe.db.exists("Academic Year", "2024-25"):
        academic_year = frappe.get_doc({
            "doctype": "Academic Year",
            "academic_year_name": "2024-25",
            "year_start_date": "2024-08-01",
            "year_end_date": "2025-07-31"
        })
        academic_year.insert()
        frappe.db.commit()
        print("✅ Academic Year created: 2024-25")
    
    # Create Programs
    programs = [
        {"program_name": "Bachelor of Tourism Management", "program_abbreviation": "BTM"},
        {"program_name": "Bachelor of Hospitality Management", "program_abbreviation": "BHM"},
        {"program_name": "Master of Tourism and Hospitality", "program_abbreviation": "MTH"},
        {"program_name": "Diploma in Hotel Management", "program_abbreviation": "DHM"},
        {"program_name": "Certificate in Culinary Arts", "program_abbreviation": "CCA"}
    ]
    
    for prog in programs:
        if not frappe.db.exists("Program", prog["program_name"]):
            program = frappe.get_doc({
                "doctype": "Program",
                "program_name": prog["program_name"],
                "program_abbreviation": prog["program_abbreviation"]
            })
            program.insert()
            frappe.db.commit()
            print(f"✅ Program created: {prog['program_name']}")
    
    # Create Course Categories
    categories = ["Core Courses", "Elective Courses", "Practical Training", "Industry Exposure"]
    for cat in categories:
        if not frappe.db.exists("Course Category", cat):
            category = frappe.get_doc({
                "doctype": "Course Category",
                "category": cat
            })
            category.insert()
            frappe.db.commit()
            print(f"✅ Course Category created: {cat}")
    
    # Create Sample Courses
    courses = [
        {"course_name": "Tourism Geography", "course_code": "TG101", "category": "Core Courses"},
        {"course_name": "Hospitality Operations", "course_code": "HO201", "category": "Core Courses"},
        {"course_name": "Event Management", "course_code": "EM301", "category": "Elective Courses"},
        {"course_name": "Culinary Skills", "course_code": "CS401", "category": "Practical Training"},
        {"course_name": "Hotel Internship", "course_code": "HI501", "category": "Industry Exposure"}
    ]
    
    for course in courses:
        if not frappe.db.exists("Course", course["course_name"]):
            course_doc = frappe.get_doc({
                "doctype": "Course",
                "course_name": course["course_name"],
                "course_code": course["course_code"],
                "course_category": course["category"]
            })
            course_doc.insert()
            frappe.db.commit()
            print(f"✅ Course created: {course['course_name']}")
    
    # Create Instructors
    instructors = [
        {"first_name": "Dr. Sarah", "last_name": "Johnson", "email": "sarah.johnson@ithm.edu", "department": "Tourism Studies"},
        {"first_name": "Prof. Michael", "last_name": "Chen", "email": "michael.chen@ithm.edu", "department": "Hospitality Management"},
        {"first_name": "Chef Maria", "last_name": "Rodriguez", "email": "maria.rodriguez@ithm.edu", "department": "Culinary Arts"}
    ]
    
    for inst in instructors:
        email = inst["email"]
        if not frappe.db.exists("Instructor", {"email": email}):
            instructor = frappe.get_doc({
                "doctype": "Instructor",
                "instructor_name": f"{inst['first_name']} {inst['last_name']}",
                "email": email,
                "department": inst["department"]
            })
            instructor.insert()
            frappe.db.commit()
            print(f"✅ Instructor created: {inst['first_name']} {inst['last_name']}")

if __name__ == "__main__":
    setup_ithm()
EOF

# Run the setup script
bench --site ithm.local execute /tmp/setup_ithm.py

# Clean up
rm /tmp/setup_ithm.py

echo "🎉 Setup completed successfully!"
echo ""
echo "🌐 Access your ERPNext Education Portal at: http://localhost:8000"
echo "🔑 Login credentials:"
echo "   Username: Administrator"
echo "   Password: admin123"
echo ""
echo "🏫 Institute: Institute of Tourism and Hospitality Management"
echo "📚 Education Portal is ready with sample data!"

# Start the development server
bench start