# 🔥 HeatCode AWS EC2 Deployment Guide

## 🎯 Summary

Your HeatCode application is now ready for deployment with beautiful UI and guaranteed superuser access! Here's everything you need to know:

## ✅ What's Been Implemented

### 🎨 Modern UI Features
- **Beautiful glassmorphism design** with gradients and modern effects
- **Responsive layout** that works on desktop and mobile
- **Enhanced dashboard** with problem difficulty badges, tags, and company information
- **Improved forms** with icons and better styling
- **Professional login/register pages** with validation
- **Enhanced problem detail pages** with organized sections
- **Modern code editor interface** with syntax highlighting

### 🔧 Technical Improvements
- **"Solve" buttons** added to dashboard - redirects to compiler with the selected problem
- **Environment-based configuration** for production deployment
- **Docker containerization** with production-ready setup
- **PostgreSQL support** for production database
- **Automated superuser creation** with environment variables
- **Sample problems** automatically created on first run
- **Security hardening** for production environment

### 🔐 Guaranteed Superuser Access

The system automatically creates a superuser with these credentials:
- **Username**: `admin`
- **Email**: `admin@heatcode.com`  
- **Password**: `HeatCode123!`

**Access Points:**
- Admin Panel: `http://your-domain/admin`
- Dashboard: `http://your-domain/dashboard`

## 🚀 Quick AWS EC2 Deployment

### Method 1: Automated Script (Recommended)

1. **Launch EC2 Instance** (Ubuntu 20.04+, t3.small recommended)

2. **Upload your code**:
   ```bash
   scp -r . ubuntu@your-ec2-ip:~/heatcode/
   ```

3. **SSH and deploy**:
   ```bash
   ssh ubuntu@your-ec2-ip
   cd ~/heatcode
   chmod +x deploy-aws.sh
   ./deploy-aws.sh
   ```

4. **Access your application**:
   - Site: `http://your-ec2-ip`
   - Admin: `http://your-ec2-ip/admin`

### Method 2: Manual Docker Deployment

1. **Install Docker on EC2**:
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker $USER
   ```

2. **Install Docker Compose**:
   ```bash
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

3. **Create environment file**:
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. **Deploy**:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

## 🔧 Environment Configuration

### Required Environment Variables

Create a `.env` file with:

```env
# Basic Configuration
DEBUG=0
DJANGO_SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=your-ec2-ip,your-domain.com

# Superuser (will be auto-created)
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@heatcode.com
DJANGO_SUPERUSER_PASSWORD=HeatCode123!

# Database (for production with PostgreSQL)
POSTGRES_PASSWORD=your-secure-password
POSTGRES_DB=heatcode
POSTGRES_USER=postgres
```

### Generate Secret Key

```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

## 🛡️ Security Setup

### 1. AWS Security Groups
Configure these inbound rules:
```
SSH (22): Your IP only
HTTP (80): 0.0.0.0/0
HTTPS (443): 0.0.0.0/0 (if using SSL)
```

### 2. Change Default Credentials
**IMMEDIATELY** after deployment:
1. Go to `/admin`
2. Login with `admin` / `HeatCode123!`
3. Change the password
4. Update email if needed

### 3. SSL/HTTPS (Recommended)
For production, configure SSL:
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 📊 System Requirements

### Minimum (Development):
- **Instance**: t2.micro (1 vCPU, 1GB RAM)
- **Storage**: 8GB

### Recommended (Production):
- **Instance**: t3.small (2 vCPUs, 2GB RAM) 
- **Storage**: 20GB SSD
- **Network**: Enhanced networking enabled

## 🔍 Post-Deployment Checklist

### ✅ Immediate Tasks:
1. [ ] Verify application is accessible
2. [ ] Login to admin panel and change password
3. [ ] Test user registration and login
4. [ ] Test problem solving functionality
5. [ ] Check that "Solve" buttons work correctly
6. [ ] Verify responsive design on mobile

### ✅ Production Hardening:
1. [ ] Configure SSL/HTTPS
2. [ ] Set up monitoring (CloudWatch)
3. [ ] Configure backups
4. [ ] Set up log rotation
5. [ ] Configure firewall rules
6. [ ] Set up domain name (if applicable)

## 🎯 Key Features to Test

### 1. User Journey:
- Visit homepage → Register → Login → Dashboard → View Problem → Solve Problem

### 2. Admin Functions:
- Access `/admin` → Add problems → Add test cases → Manage users

### 3. Problem Solving:
- Click "Solve" button on dashboard
- Test code compilation in multiple languages
- Verify test case execution

## 🚨 Troubleshooting

### Common Issues:

**Application not accessible:**
```bash
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs
```

**Database issues:**
```bash
docker-compose -f docker-compose.prod.yml exec db psql -U postgres -d heatcode
```

**Permission issues:**
```bash
sudo chown -R $USER:$USER /home/$USER/heatcode
```

### Emergency Access:
If you lose admin access, create a new superuser:
```bash
docker-compose -f docker-compose.prod.yml exec web python manage.py createsuperuser
```

## 📱 Monitoring & Maintenance

### View Logs:
```bash
# All services
docker-compose -f docker-compose.prod.yml logs -f

# Specific service
docker-compose -f docker-compose.prod.yml logs -f web
```

### Update Application:
```bash
git pull origin main
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d
```

### Database Backup:
```bash
docker-compose -f docker-compose.prod.yml exec db pg_dump -U postgres heatcode > backup.sql
```

## 🎉 Success!

If everything is working correctly, you should see:

1. **🏠 Homepage**: Beautiful landing page with gradient effects
2. **👤 Authentication**: Smooth login/register experience  
3. **📊 Dashboard**: Modern problem list with difficulty badges and "Solve" buttons
4. **🔧 Problem Solving**: Split-screen interface with problem description and code editor
5. **⚙️ Admin Panel**: Full administrative access to manage problems and users

**Your HeatCode platform is now production-ready! 🚀**

---

### 📞 Need Help?

If you encounter any issues:
1. Check the troubleshooting section above
2. Review Docker logs
3. Verify environment variables
4. Ensure all ports are accessible

**Happy coding! 🔥**
