#Trend App

The project contain 2 part one is - infra setup for the server - Trend git application part

### Infra set up

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

#### Jenkins 
1. open the jenkins <ec2ip>:8080
2. cat /var/lib/jenkins/secrets/initialAdminPassword
3. Install plugins like docker , docker pipeline , stage view, kubernetes
4. add credidentials like docker-cred and git-cred to the credentials

   ###### Set up docker
   sudo apt update
   sudo apt install docker.io -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker jenkins
   sudo systemctl restart jenkins


#### Kubernetes
eksctl create cluster \
--name trend-cluster-final \
--region us-east-1 \
--nodegroup-name trend-nodes \
--node-type t3.medium \
--nodes 2 \
--nodes-min 2 \
--nodes-max 3 \
--managed

aws eks --region us-east-1 update-kubeconfig --name trend-cluster-final

sudo -u jenkins aws eks --region us-east-1 update-kubeconfig --name trend-cluster-final

sudo su - jenkins
kubectl get nodes

