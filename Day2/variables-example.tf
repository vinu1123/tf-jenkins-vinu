resource "aws_instance" "ubuntu_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  # Ensure EC2 instance is created only after the key pair
  depends_on = [aws_key_pair.generated_key]

  tags = merge(
    {
      Name = var.instance_name
    },
    var.additional_tags
  )
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

variable "aws_region" {
  description = "AWS region for the instance"
  type        = string
  default     = "ap-southeast-2"
}

variable "key_pair" {
  description = "EC2 instance key pair"
  type        = string
  default     = "arjun1"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for ubuntu in the selected region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "enable_monitoring" {
  description = "Enable monitoring for the instance"
  type        = bool
  default     = true
}

variable "volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "security_groups" {
  description = "List of security groups to attach to the instance"
  type        = list(string)
  default     = ["sg-12345678", "sg-87654321"]
}

variable "additional_tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {
    Environment = "Dev"
    Owner       = "Admin"
    fdsfsdf = "fdsfdsfsd"
  }
}

variable "network_config" {
  description = "Network configuration for the instance"
  type = object({
    subnet_id            = string
    associate_public_ip  = bool
  })
  default = {
    subnet_id           = "subnet-abcdefgh"
    associate_public_ip = true
  }
}

provider "aws" {
  region = var.aws_region
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ubuntu_vm.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ubuntu_vm.public_ip
}

output "private_key_pem" {
  description = "Private key for SSH access"
  value       = aws_key_pair.generated_key.id
  sensitive   = true
}
