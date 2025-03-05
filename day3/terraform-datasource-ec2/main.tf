terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Get current AWS region
data "aws_region" "current" {}

# Get availability zones
data "aws_availability_zones" "available" {}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch a single public subnet by specifying the first AZ
data "aws_subnet" "default_public" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zones.available.names[0]  # Pick first AZ
}


# Get your public IP (for SSH access restriction)
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Create Security Group
resource "aws_security_group" "ssh_sg" {
  name        = "allow_ssh"
  description = "Allow SSH access from my IP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  availability_zone      = data.aws_availability_zones.available.names[0]
  subnet_id             = data.aws_subnet.default_public.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "Terraform-EC2"
  }
}

# Create and Attach EBS Volume
resource "aws_ebs_volume" "storage" {
  availability_zone = aws_instance.web.availability_zone
  size             = 10 # 10 GB
}

resource "aws_volume_attachment" "attach_ebs" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.storage.id
  instance_id = aws_instance.web.id
}
