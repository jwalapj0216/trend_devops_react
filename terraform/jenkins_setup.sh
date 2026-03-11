#!/bin/bash
set -e

# ----------------------------------------
# 5. Install Jenkins Plugin Manager
# ----------------------------------------
sudo su 

echo "Installing Jenkins Plugin Manager..."
sudo wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.13.2/jenkins-plugin-manager-2.13.2.jar \
  -O /usr/local/bin/jenkins-plugin-manager.jar
sudo chmod +x /usr/local/bin/jenkins-plugin-manager.jar
# ----------------------------------------
# 6. Define Jenkins plugins
# ----------------------------------------
echo "Creating plugins list..."
mkdir -p /var/lib/jenkins/plugins
cat <<EOF > /var/lib/jenkins/plugins/plugins.txt
git
workflow-aggregator
docker-plugin
docker-workflow
kubernetes
credentials-binding
pipeline-stage-view
email-ext
configuration-as-code
EOF

# ----------------------------------------
# 7. Install Jenkins plugins
# ----------------------------------------
echo "Installing Jenkins plugins..."
java -jar /usr/local/bin/jenkins-plugin-manager.jar \
--plugin-file /var/lib/jenkins/plugins/plugins.txt \
--war /usr/share/java/jenkins.war

# ----------------------------------------
# 8. Configure Jenkins as Code (admin user, password)
# ----------------------------------------
# Apply Jenkins Configuration as Code and skip unlock
echo "Setting up Jenkins Configuration as Code..."
mkdir -p /var/lib/jenkins/casc_configs

cat <<EOF > /var/lib/jenkins/casc_configs/jenkins.yaml
jenkins:
  systemMessage: "Automated Jenkins Server for Docker & Kubernetes CI/CD 🚀"

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

# Set JCasC environment variable
echo 'CASC_JENKINS_CONFIG=/var/lib/jenkins/casc_configs' >> /etc/default/jenkins

# Remove initialAdminPassword to skip unlock
rm -f /var/lib/jenkins/secrets/initialAdminPassword

# Restart Jenkins to apply everything
systemctl restart jenkins