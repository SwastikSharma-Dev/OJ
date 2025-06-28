# 🔥 HeatCode - Ultimate Coding Challenge Platform

HeatCode is a modern, feature-rich coding challenge platform built with Django. It provides an interactive environment for solving programming problems with real-time code execution in multiple languages.

## ✨ Features

- **🌟 Beautiful Modern UI** - Clean, responsive design with glassmorphism effects
- **💻 Multi-language Support** - Python, C, C++, Java
- **⚡ Real-time Code Execution** - Instant feedback on your solutions
- **🎯 Progressive Difficulty** - Easy to Hard problems
- **🏢 Company Problems** - Practice problems from top tech companies
- **🏷️ Tag System** - Organized by topics (Array, String, Math, etc.)
- **👤 User Authentication** - Secure login and registration
- **📊 Problem Management** - Admin interface for adding problems

## 🚀 Quick Start (Development)

### Prerequisites

- Python 3.11+
- Docker and Docker Compose (for containerized deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd mainWebsite
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run migrations**
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

4. **Create a superuser**
   ```bash
   python manage.py createsuperuser
   ```

5. **Start the development server**
   ```bash
   python manage.py runserver
   ```

6. **Access the application**
   - Main site: http://localhost:8000
   - Admin panel: http://localhost:8000/admin

## 🐳 Docker Deployment

### Development with Docker

```bash
docker-compose up --build
```

### Production Deployment

```bash
docker-compose -f docker-compose.prod.yml up --build -d
```

## ☁️ AWS EC2 Deployment

### Automated Deployment

We provide an automated deployment script for AWS EC2:

1. **Launch an EC2 instance** (Ubuntu 20.04 or later recommended)

2. **Upload your code** to the EC2 instance:
   ```bash
   scp -r . ubuntu@your-ec2-ip:~/heatcode/
   ```

3. **SSH into your EC2 instance**:
   ```bash
   ssh ubuntu@your-ec2-ip
   cd ~/heatcode
   ```

4. **Run the deployment script**:
   ```bash
   chmod +x deploy-aws.sh
   ./deploy-aws.sh
   ```

5. **Configure security groups** to allow traffic on ports 80 and 443

### Manual Deployment

If you prefer manual deployment:

1. **Install Docker and Docker Compose** on your EC2 instance

2. **Create environment file**:
   ```bash
   cp .env.example .env
   # Edit .env with your production settings
   ```

3. **Deploy with production compose**:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

## 🔐 Environment Variables

Create a `.env` file based on `.env.example` and configure:

```env
# Django Configuration
DEBUG=0
DJANGO_SECRET_KEY=your-very-secret-key-here
ALLOWED_HOSTS=your-domain.com,your-ip

# Superuser Configuration
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@heatcode.com
DJANGO_SUPERUSER_PASSWORD=HeatCode123!

# Database (for PostgreSQL in production)
POSTGRES_PASSWORD=your-db-password
POSTGRES_DB=heatcode
POSTGRES_USER=postgres
```

## 🔑 Default Superuser Access

When deployed, the system automatically creates a superuser with these credentials:

- **Username**: `admin`
- **Password**: `HeatCode123!`
- **Email**: `admin@heatcode.com`

**⚠️ IMPORTANT**: Change these credentials immediately after deployment!

### Accessing Admin Panel

1. Go to `http://your-domain.com/admin` or `http://your-ec2-ip/admin`
2. Login with the superuser credentials
3. Change the password immediately
4. Start adding problems and managing users

## 📝 Adding Problems

1. Access the admin panel
2. Go to "Problems" section
3. Click "Add Problem"
4. Fill in the details:
   - Problem ID (unique identifier)
   - Title
   - Description
   - Constraints
   - Difficulty (Easy/Medium/Hard)
   - Tags (Array, String, Math, etc.)
   - Companies (Google, Amazon, etc.)
5. Add test cases in the "Test Cases" section

## 🛡️ Security Considerations

### For Production Deployment:

1. **Change default credentials** immediately
2. **Use HTTPS** - Configure SSL/TLS certificates
3. **Firewall configuration**:
   - Allow ports 22 (SSH), 80 (HTTP), 443 (HTTPS)
   - Restrict SSH access to your IP
4. **Database security** - Use strong passwords
5. **Regular updates** - Keep system and dependencies updated

### Recommended Security Groups (AWS):

```
Inbound Rules:
- SSH (22): Your IP only
- HTTP (80): 0.0.0.0/0
- HTTPS (443): 0.0.0.0/0

Outbound Rules:
- All traffic: 0.0.0.0/0
```

## 🔧 Troubleshooting

### Common Issues:

1. **Permission denied on deployment script**:
   ```bash
   chmod +x deploy-aws.sh
   ```

2. **Docker service not running**:
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

3. **Port already in use**:
   ```bash
   docker-compose down
   sudo lsof -i :80
   ```

4. **Database connection issues**:
   - Check if PostgreSQL container is running
   - Verify environment variables
   - Check Docker network connectivity

### Viewing Logs:

```bash
# View all container logs
docker-compose -f docker-compose.prod.yml logs

# View specific service logs
docker-compose -f docker-compose.prod.yml logs web
```

## 📊 System Requirements

### Minimum Requirements:
- **CPU**: 1 vCPU
- **RAM**: 1 GB
- **Storage**: 10 GB
- **OS**: Ubuntu 20.04+ or Amazon Linux 2

### Recommended for Production:
- **CPU**: 2 vCPUs
- **RAM**: 2 GB
- **Storage**: 20 GB SSD
- **Instance Type**: t3.small or t3.medium

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

If you encounter any issues:

1. Check the troubleshooting section
2. Review the logs
3. Check environment variables
4. Ensure all dependencies are installed

---

**🔥 Happy Coding with HeatCode! 🔥**
