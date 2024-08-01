# Running Terraform
Apply the configuration, providing the necessary variables

+ Initialize Terraform
```sh
terraform init
terraform fmt
terraform validate
terraform plan
```

- Apply the configuration, providing the necessary variables

```sh
terraform apply -var="key_name=your-key-name" -var="aws_access_key_id=your-access-key-id" -var="aws_secret_access_key=your-secret-access-key"
terraform apply -var="key_name=your-key-name" -var="aws_access_key_id=your-access-key-id" -var="aws_secret_access_key=your-secret-access-key" --auto-approve
```