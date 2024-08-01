+ Here’s a single command that will create the folders and files:

```sh
mkdir -p project/ec2_instance project/eks_cluster && \
touch project/ec2_instance/ec2_instance.tf project/ec2_instance/create_eks_cluster.sh && \
touch project/eks_cluster/eks_cluster.tf project/eks_cluster/variables.tf project/eks_cluster/outputs.tf project/eks_cluster/provider.tf && \
touch project/main.tf project/variables.tf project/terraform.tfvars
```

* Environment Variables
> To avoid hardcoding AWS credentials, you can set environment variables before running Terraform:
```sh
export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
export AWS_REGION="us-west-2"
```

