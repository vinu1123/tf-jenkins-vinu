resource "aws_instance" "my_ec2" {
  ami           = "ami-09e143e99e8fa74f9"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 8  # Default root volume
  }

  tags = {
    Name = "manual-ec2-throiugh-tf"
  }
}

resource "aws_ebs_volume" "extra_storage" {
  availability_zone = "ap-southeast-2a"
  size             = 20

  tags = {
    Name = "ExtraStorage"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.extra_storage.id
  instance_id = aws_instance.my_ec2.id
}
