# ERPNext ITHM Education Portal - Environment Configuration

# Database Configuration
DB_HOST=db
DB_PORT=3306
DB_NAME=erpnext
DB_USER=erpnext
DB_PASSWORD=erpnext123
MYSQL_ROOT_PASSWORD=admin123

# Redis Configuration
REDIS_CACHE_URL=redis://redis-cache:6379
REDIS_QUEUE_URL=redis://redis-queue:6379
REDIS_SOCKETIO_URL=redis://redis-socketio:6379

# ERPNext Configuration
SITE_NAME=ithm.local
ADMIN_PASSWORD=admin123
FRAPPE_USER=frappe
FRAPPE_USER_PASSWORD=frappe123

# Application Settings
DEVELOPER_MODE=1
MUTE_EMAILS=1
DISABLE_WEBSITE_CACHE=1
AUTO_EMAIL_REPORTS=0
SERVE_DEFAULT_SITE=1

# Institute Configuration
INSTITUTE_NAME=Institute of Tourism and Hospitality Management
INSTITUTE_ABBR=ITHM
INSTITUTE_COUNTRY=United States
INSTITUTE_CURRENCY=USD

# Security (Change in production)
SECRET_KEY=your-secret-key-here
ENCRYPTION_KEY=your-encryption-key-here

# Email Configuration (Optional)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=1
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

# SSL Configuration (Production)
SSL_CERTIFICATE_PATH=/path/to/certificate.crt
SSL_PRIVATE_KEY_PATH=/path/to/private.key

# Backup Configuration
BACKUP_FREQUENCY=daily
BACKUP_RETENTION_DAYS=30
BACKUP_LOCATION=/home/frappe/frappe-bench/sites/ithm.local/private/backups

# Performance Settings
MAX_WORKERS=4
WORKER_TIMEOUT=120
KEEP_ALIVE=2

# Development Settings
DEBUG=0
LOG_LEVEL=INFO
BENCH_RESTART=1

# External Services (Optional)
GOOGLE_MAPS_API_KEY=your-google-maps-api-key
RAZORPAY_KEY_ID=your-razorpay-key
RAZORPAY_KEY_SECRET=your-razorpay-secret
STRIPE_PUBLISHABLE_KEY=your-stripe-publishable-key
STRIPE_SECRET_KEY=your-stripe-secret-key

# Notification Settings
SLACK_WEBHOOK_URL=your-slack-webhook-url
DISCORD_WEBHOOK_URL=your-discord-webhook-url

# Analytics (Optional)
GOOGLE_ANALYTICS_ID=UA-XXXXXXXXX-X
MIXPANEL_TOKEN=your-mixpanel-token

# Storage Configuration (Production)
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_S3_BUCKET_NAME=your-s3-bucket
AWS_REGION=us-east-1

# CDN Configuration (Production)
CDN_URL=https://your-cdn-domain.com

# Time Zone
TIMEZONE=America/New_York

# Language and Locale
DEFAULT_LANGUAGE=en
DEFAULT_COUNTRY=US

# Institution Specific
ACADEMIC_YEAR_START_MONTH=8
ACADEMIC_YEAR_END_MONTH=7
GRADUATION_MONTH=5
ADMISSION_START_MONTH=1
ADMISSION_END_MONTH=6

# Contact Information
INSTITUTE_EMAIL=info@ithm.edu
INSTITUTE_PHONE=+1-555-123-4567
INSTITUTE_ADDRESS=123 Education Lane, Learning City, ST 12345
INSTITUTE_WEBSITE=https://www.ithm.edu

# Social Media
FACEBOOK_URL=https://facebook.com/ithm
TWITTER_URL=https://twitter.com/ithm
INSTAGRAM_URL=https://instagram.com/ithm
LINKEDIN_URL=https://linkedin.com/company/ithm