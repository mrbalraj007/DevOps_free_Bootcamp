# Define the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Create an ECR repository
resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my-docker-repo" # Change this to your preferred repository name
  image_tag_mutability = "MUTABLE"        # Allows images to be overwritten with the same tag
  image_scanning_configuration {
    scan_on_push = true # Enables image scanning on push for vulnerabilities
  }
}

# Optional: Apply lifecycle policies to remove untagged images
resource "aws_ecr_lifecycle_policy" "my_lifecycle_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

# Output the repository URL for use in pushing Docker images
output "ecr_repository_url" {
  value       = aws_ecr_repository.my_ecr_repo.repository_url
  description = "The URL of the ECR repository"
}

