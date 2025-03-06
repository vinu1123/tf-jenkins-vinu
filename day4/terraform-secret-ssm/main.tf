provider "aws" {
  region = "ap-southeast-2"
}

# Store a secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "my_secret" {
  name = "my-app-secret"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "SuperSecurePassword123"
  })
}

# Store a sensitive value in AWS SSM Parameter Store
data "aws_ssm_parameter" "my_parameter" {
  name  = "/myapp/db_password"
  type  = "SecureString"
  value = "AnotherSecurePassword456"
}

# Output ARNs (Sensitive Data Masked)
output "secrets_manager_arn" {
  value     = aws_secretsmanager_secret.my_secret.arn
  sensitive = true
}

output "ssm_parameter_name" {
  value     = aws_ssm_parameter.my_parameter.name
  sensitive = true
}
