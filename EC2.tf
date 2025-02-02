# Terraform AWS Infrastructure Project

provider "aws" {
  region = "us-east-1"
}

# Define S3 Backend (Uncomment and configure if needed)
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#   }
# }

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
}

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-bucket-12345"
  acl    = "private"
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (update as needed)
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
              EOF
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
