#!/bin/bash
set -e

echo "Jenkins install script start" > /tmp/script_test.txt

echo "Updating packages..."
sudo apt update -y

echo "Installing Java..."
sudo apt install -y fontconfig openjdk-21-jre

java -version

echo "Adding Jenkins repository..."

sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Updating package list again..."
sudo apt update -y

echo "Installing Jenkins..."
sudo apt install -y jenkins

echo "Starting Jenkins service..."
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Jenkins install script end" >> /tmp/script_test.txt

echo "Starting DevOps script start" >> /tmp/script_test.txt

echo "Starting DevOps tools installation..."

# Update packages
echo "Updating system packages..."
sudo apt update -y

# Install required utilities
echo "Installing dependencies..."
sudo apt install -y curl unzip wget


# Install AWS CLI v2

echo "Installing AWS CLI..."

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

aws --version


# Install kubectl

echo "Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

kubectl version --client


# Install eksctl

echo "Installing eksctl..."

curl --silent --location \
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

eksctl version

echo "Installation completed successfully!"
echo "Starting DevOps script end" >> /tmp/script_test.txt

