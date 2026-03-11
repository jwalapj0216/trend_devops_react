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

echo "Installing Jenkins Plugin CLI..."

wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/latest/download/jenkins-plugin-manager.jar -O /usr/local/bin/jenkins-plugin-manager.jar

mkdir -p /usr/share/jenkins/ref/plugins

echo "Creating plugins list..."

cat <<EOF > /tmp/plugins.txt
git
docker-plugin
docker-workflow
kubernetes
workflow-aggregator
blueocean
credentials-binding
pipeline-stage-view
email-ext
EOF

echo "Installing Jenkins plugins..."
# Jenkins Configuration as Code
############################################################

mkdir -p /var/lib/jenkins/casc_configs

cat <<EOF > /var/lib/jenkins/casc_configs/jenkins.yaml
jenkins:
  systemMessage: "Jenkins Automated by Terraform 🚀"

  numExecutors: 2

  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: admin
          password: admin123

  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false

unclassified:
  location:
    url: http://localhost:8080/
EOF


# Enable Jenkins Configuration as Code


echo 'CASC_JENKINS_CONFIG=/var/lib/jenkins/casc_configs' >> /etc/default/jenkins

# Permissions

chown -R jenkins:jenkins /var/lib/jenkins


# Restart Jenkins
systemctl restart jenkins

echo "Jenkins installation completed!"
echo "Access Jenkins at: http://<SERVER-IP>:8080"