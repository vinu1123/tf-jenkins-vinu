OPTION 1
terraform apply \
  -var="aws_region=ap-southeast-2" \
  -var="key_pair=arjun1" \
  -var="instance_name=Ubuntu-Server" \
  -var="ami_id=ami-0fc5d935ebf8bc3bc" \
  -var="instance_type=t2.micro"

OPTION 2
export TF_VAR_aws_region="ap-southeast-2"
export TF_VAR_key_pair="arjun1"
export TF_VAR_instance_name="Ubuntu-Server"
export TF_VAR_ami_id="ami-0fc5d935ebf8bc3bc"
export TF_VAR_instance_type="t2.micro"

terraform apply

OPTION 3 using tfvars

terrform apply -var-file=dev.tfvars
