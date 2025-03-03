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
