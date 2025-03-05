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

# 🔹 Create an SSH Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("my-key.pub")  # Reads the public key from your local system
}

# 🔹 Create an EC2 Instance (Ubuntu)
resource "aws_instance" "app_server" {
  ami           = "ami-09e143e99e8fa74f9"  # Replace with the correct Ubuntu AMI for your region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name  # Assigns the created key pair

  tags = {
    Name = "Ubuntu-Server"
  }

  # 🔹 Define the SSH Connection (for Ubuntu)
  connection {
    type        = "ssh"
    user        = "ubuntu"  # Default user for Ubuntu instances
    private_key = file("my-key")  # Uses the private key to connect
    host        = self.public_ip
  }

  # 🔹 remote-exec Provisioner (Runs commands inside Ubuntu EC2 instance)
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }
}

# 🔹 Output Public IP Address
output "instance_ip" {
  value = aws_instance.app_server.public_ip
  description = "Public IP of the EC2 instance"
}
