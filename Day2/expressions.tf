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

# --------------------------
# Literal Values (Strings, Numbers, Booleans, Lists, Maps)
# --------------------------
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "instance_tags" {
  description = "Map of instance tags"
  type        = map(string)
  default = {
    Name    = "TerraformInstance"
    Owner   = "Arjun"
    Project = "Terraform Practice"
  }
}

# --------------------------
# References (Variables, Resources, Data Sources)
# --------------------------
resource "aws_instance" "app_server" {
  ami           = "ami-09e143e99e8fa74f9"
  instance_type = var.instance_type

  tags = var.instance_tags
}

# Security Group to allow specified ports
resource "aws_security_group" "windows_sg" {
  name        = "windows-rdp-sg1"
  description = "Allow RDP access"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------
# Functions (Built-in Terraform Functions)
# --------------------------
output "uppercase_owner" {
  description = "Convert Owner tag to uppercase"
  value       = upper(var.instance_tags["Owner"])
}

output "timestamp_now" {
  description = "Current timestamp"
  value       = timestamp()
}

output "random_list_element" {
  description = "Pick a random port from the list"
  value       = element(var.allowed_ports, 1) # Picks the second element (80)
}

# --------------------------
# Operators (Arithmetic, Comparison, Logical)
# --------------------------
output "compute_addition" {
  description = "Arithmetic operation result"
  value       = 10 + 5
}

output "is_production" {
  description = "Check if the instance is for production"
  value       = var.instance_type == "t3.large"
}

output "logical_check" {
  description = "Logical AND operation"
  value       = var.enable_monitoring && (var.instance_type == "t3.micro")
}

# --------------------------
# Conditional Expressions
# --------------------------
output "selected_instance_type" {
  description = "Select instance type based on environment"
  value       = var.instance_type == "t3.large" ? "High performance" : "Standard"
}

resource "aws_instance" "windows_vm" {
  ami           = "ami-00cf40ed19c0fca69"
  instance_type = var.instance_type == "t3.large" ? "t3.large" : "t3.micro"

  key_name        = "Arjun"
  security_groups = [aws_security_group.windows_sg.name]

  tags = {
    Name = "WindowsVM-Terraform"
  }
}

# --------------------------
# For Expressions
# --------------------------
variable "names" {
  description = "List of names"
  type        = list(string)
  default     = ["alice", "bob", "charlie"]
}

output "uppercase_names" {
  description = "Convert names to uppercase"
  value       = [for name in var.names : upper(name)]
}

output "filtered_ports" {
  description = "Filter even ports from allowed_ports"
  value       = [for port in var.allowed_ports : port if port % 2 == 0]
}

# --------------------------
# Key Pair Resource
# --------------------------
resource "aws_key_pair" "generated_key" {
  key_name   = "deployer-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
