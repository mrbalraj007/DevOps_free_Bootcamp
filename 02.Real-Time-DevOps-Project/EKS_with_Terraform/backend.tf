terraform {
  backend "s3" {
    bucket = "mrsinghbucket080320222"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}