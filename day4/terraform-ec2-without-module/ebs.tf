resource "aws_ebs_volume" "web_volume" {
  availability_zone = "ap-southeast-2a"
  size             = 10

  tags = {
    Name = "web-ebs"
  }
}

resource "aws_volume_attachment" "web_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.web_volume.id
  instance_id = aws_instance.app_server.id
}
