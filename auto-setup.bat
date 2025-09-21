@echo off
REM ITHM ERPNext Complete Automated Setup Script for Windows
REM This script installs everything needed for ITHM education management system

echo 🚀 Starting ITHM ERPNext Complete Setup...
echo ==============================================

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [ERROR] Please do not run this script as administrator. Run as a regular user.
    pause
    exit /b 1
)

REM Install Chocolatey if not present
echo [INFO] Installing Chocolatey package manager...
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

REM Install prerequisites using Chocolatey
echo [INFO] Installing prerequisites...
choco install -y python3 nodejs git redis mariadb nginx

REM Install Python packages
echo [INFO] Installing Python packages...
pip install frappe-bench

REM Start services
echo [INFO] Starting services...
net start redis
net start mariadb

REM Create frappe user (Windows equivalent)
echo [INFO] Setting up frappe user...
net user frappe /add /passwordreq:no
net localgroup administrators frappe /add

REM Create frappe directory
mkdir C:\frappe
mkdir C:\frappe\frappe-bench

REM Switch to frappe user context and install ERPNext
echo [INFO] Installing ERPNext...
runas /user:frappe "cmd /c cd C:\frappe && bench init frappe-bench --frappe-branch version-14"

REM Continue with frappe user
runas /user:frappe "cmd /c cd C:\frappe\frappe-bench && bench new-site ithm.local --admin-password admin --db-root-password admin"
runas /user:frappe "cmd /c cd C:\frappe\frappe-bench && bench --site ithm.local install-app erpnext"
runas /user:frappe "cmd /c cd C:\frappe\frappe-bench && bench --site ithm.local install-app education"

REM Copy configuration files
echo [INFO] Copying configuration files...
copy ithm-config.json C:\frappe\frappe-bench\sites\ithm.local\
copy erpnext-config.json C:\frappe\frappe-bench\sites\ithm.local\
copy user-roles.json C:\frappe\frappe-bench\sites\ithm.local\
copy programs.json C:\frappe\frappe-bench\sites\ithm.local\
copy fee-structure.json C:\frappe\frappe-bench\sites\ithm.local\

REM Create startup script
echo [INFO] Creating startup script...
echo @echo off > C:\frappe\start-ithm.bat
echo cd C:\frappe\frappe-bench >> C:\frappe\start-ithm.bat
echo bench start >> C:\frappe\start-ithm.bat

REM Create Windows service
echo [INFO] Creating Windows service...
sc create "ITHM-ERPNext" binPath= "C:\frappe\start-ithm.bat" start= auto
sc description "ITHM-ERPNext" "ITHM ERPNext Education Management System"

REM Start the service
echo [INFO] Starting ITHM ERPNext service...
sc start "ITHM-ERPNext"

echo.
echo ==============================================
echo [SUCCESS] ITHM ERPNext Setup Complete!
echo ==============================================
echo.
echo 🌐 Access Information:
echo    URL: http://localhost:8000
echo    Username: Administrator
echo    Password: admin
echo.
echo 📁 Installation Directory:
echo    C:\frappe\frappe-bench\
echo.
echo 🔧 Management Commands:
echo    Start:   sc start "ITHM-ERPNext"
echo    Stop:    sc stop "ITHM-ERPNext"
echo    Status:  sc query "ITHM-ERPNext"
echo.
echo 📋 Configuration Files:
echo    All ITHM config files are in: C:\frappe\frappe-bench\sites\ithm.local\
echo.
echo 🎯 Next Steps:
echo    1. Access ERPNext at http://localhost:8000
echo    2. Configure company details using ithm-config.json
echo    3. Set up user roles using user-roles.json
echo    4. Configure programs using programs.json
echo    5. Set up fee structure using fee-structure.json
echo.
echo [SUCCESS] Setup completed successfully! 🎉
pause
