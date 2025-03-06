module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name       = "MyVPC"
  cidr       = var.vpc_cidr
  azs        = ["${var.aws_region}a"]
  public_subnets = [var.subnet_cidr]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.0"

  key_name   = var.key_name
  public_key = file("${var.key_name}.pub")
}
