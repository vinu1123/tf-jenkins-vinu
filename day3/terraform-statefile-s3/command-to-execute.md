Step 1: Create an S3 Bucket for Terraform State
Run these commands in AWS CLI or AWS Console:


aws s3api create-bucket --bucket my-terraform-state-bucket-arjun12 --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2

aws s3api put-bucket-versioning --bucket my-terraform-state-bucket-arjun12 --versioning-configuration Status=Enabled

Step 2: Create a DynamoDB Table for State Locking

aws dynamodb create-table \
    --table-name terraform-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region ap-southeast-2
