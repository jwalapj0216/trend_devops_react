#Trend App

The project contain 2 part one is - infra setup for the server - Trend git application part

## Infra set up

1. Create a Ec2 instance to run terraform (with admin privilage) you can also use CloudShell
   Instalation steps (Amazon linux)

   ```sh
   sudo yum install -y yum-utils shadow-utils
   sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
   sudo yum install terraform
   terraform --version
   ```

2. Copy the terraform foulder files to this instance and run terraform comands

   ```sh
   terraform init
   terraform plan
   terraform apply
   ```

3. This will create EC2 instance and install jenkins , awscli, kubectl and eksctl .
