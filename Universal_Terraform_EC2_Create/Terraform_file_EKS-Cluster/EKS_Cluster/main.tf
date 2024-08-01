provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "balraj_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "balraj-vpc"
  }
}

resource "aws_subnet" "balraj_subnet" {
  count             = 2
  vpc_id            = aws_vpc.balraj_vpc.id
  cidr_block        = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)

  tags = {
    Name = "balraj-subnet-${count.index}"
  }
}

resource "aws_security_group" "balraj_node_sg" {
  vpc_id = aws_vpc.balraj_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "balraj-node-sg"
  }
}

resource "aws_iam_role" "balraj_cluster_role" {
  name = "balraj-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "balraj_cluster_policy_attachment" {
  role       = aws_iam_role.balraj_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "balraj_node_group_role" {
  name = "balraj-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "balraj_node_group_policy_attachment" {
  role       = aws_iam_role.balraj_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "balraj_cni_policy_attachment" {
  role       = aws_iam_role.balraj_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "balraj_registry_policy_attachment" {
  role       = aws_iam_role.balraj_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "balraj" {
  name     = "balraj-cluster"
  role_arn = aws_iam_role.balraj_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.balraj_subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.balraj_cluster_policy_attachment
  ]
}

resource "aws_eks_node_group" "balraj_node_group" {
  cluster_name    = aws_eks_cluster.balraj.name
  node_group_name = "balraj-node-group"
  node_role_arn   = aws_iam_role.balraj_node_group_role.arn
  subnet_ids      = aws_subnet.balraj_subnet[*].id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.balraj_node_sg.id]
  }

  instance_types = ["t2.micro"]   # You can change here for any instance "t3.medium"

  depends_on = [
    aws_iam_role_policy_attachment.balraj_node_group_policy_attachment,
    aws_iam_role_policy_attachment.balraj_cni_policy_attachment,
    aws_iam_role_policy_attachment.balraj_registry_policy_attachment
  ]
}
