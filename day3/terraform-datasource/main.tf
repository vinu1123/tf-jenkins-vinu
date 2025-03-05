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

# Data Source: Fetch latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data Source: Get current AWS region
data "aws_region" "current" {}

# Data Source: Get default VPC ID
data "aws_vpc" "default" {
  default = true
}

# EC2 Instance using data source for AMI
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "arjun"
  }
}

# Output values to verify data sources
output "current_region" {
  value = data.aws_region.current.name
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}
