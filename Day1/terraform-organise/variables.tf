variable "aws_region" {
  description = "AWS region for the instance"
  type        = string
  default = "ap-southeast-2"
}

variable "key_pair" {
  description = "EC2 instance key pair"
  type        = string
  default = "arjun1"
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


