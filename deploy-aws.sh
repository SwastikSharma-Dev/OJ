#!/bin/bash

# HeatCode AWS EC2 Deployment Script
# This script helps deploy HeatCode to an AWS EC2 instance

echo "🔥 HeatCode AWS EC2 Deployment Script 🔥"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    print_status "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
else
    print_status "Docker is already installed"
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    print_status "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    print_status "Docker Compose is already installed"
fi

# Install Git if not installed
if ! command -v git &> /dev/null; then
    print_status "Installing Git..."
    sudo apt-get install -y git
else
    print_status "Git is already installed"
fi

# Create application directory
APP_DIR="/home/$USER/heatcode"
print_status "Creating application directory: $APP_DIR"
mkdir -p $APP_DIR
cd $APP_DIR

# Clone or update repository
if [ -d ".git" ]; then
    print_status "Updating existing repository..."
    git pull origin main
else
    print_status "Repository not found. Please upload your code manually to $APP_DIR"
    print_warning "Make sure to copy all your project files to $APP_DIR"
fi

# Create environment file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating environment file..."
    cp .env.example .env
    
    # Generate a random secret key
    SECRET_KEY=$(python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())' 2>/dev/null || openssl rand -base64 32)
    
    # Get the public IP of the EC2 instance
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    
    # Update .env file with actual values
    sed -i "s/your-very-secret-key-here-change-this-in-production/$SECRET_KEY/" .env
    sed -i "s/your-ec2-instance-ip/$PUBLIC_IP/" .env
    
    print_status "Environment file created. Please review and update .env file with your preferred settings:"
    print_warning "Default superuser credentials:"
    print_warning "  Username: admin"
    print_warning "  Password: HeatCode123!"
    print_warning "  Email: admin@heatcode.com"
else
    print_status "Environment file already exists"
fi

# Build and start the application
print_status "Building and starting HeatCode application..."
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to start
print_status "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
    print_status "✅ HeatCode is successfully deployed!"
    print_status "🌐 Access your application at: http://$PUBLIC_IP"
    print_status "👤 Admin panel: http://$PUBLIC_IP/admin"
    print_status ""
    print_status "📋 Default superuser credentials:"
    print_status "   Username: admin"
    print_status "   Password: HeatCode123!"
    print_status ""
    print_warning "🔒 Security recommendations:"
    print_warning "1. Change the default superuser password"
    print_warning "2. Update the Django secret key in .env"
    print_warning "3. Configure your domain name in ALLOWED_HOSTS"
    print_warning "4. Set up SSL/HTTPS for production"
    print_warning "5. Configure firewall rules (allow ports 80, 443, 22)"
else
    print_error "❌ Deployment failed. Check logs with: docker-compose -f docker-compose.prod.yml logs"
fi

print_status "🎉 Deployment script completed!"
