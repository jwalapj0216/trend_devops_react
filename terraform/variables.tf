variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "instance_type" {
  default = "t3.medium"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  default = "us-east-1"
}

variable "sub_availability_zone" {
  default = "us-east-1a"
}

variable "ubuntu_ami_filter" {
  description = "Ubuntu 22.04 AMI filter"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}
