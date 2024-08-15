# network.tf
resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s_vpc"
  }
}

resource "aws_subnet" "k8s_subnet" {
  count = 3
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.k8s_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "k8s_subnet_${count.index + 1}"
  }
}

data "aws_availability_zones" "available" {}
