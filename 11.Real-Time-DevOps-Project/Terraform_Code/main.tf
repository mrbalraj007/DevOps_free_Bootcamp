# Fetch the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"] # For Ubuntu Instance.
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical owner ID for Ubuntu AMIs
}

# Create IAM Role
resource "aws_iam_role" "Starbucks_jenkins_policy" {
  name = "starbucks_policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM permissions

# Attach Full AmazonEC2FullAccess Permissions to IAM Role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.Starbucks_jenkins_policy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}


# Create Profile for EC2 
resource "aws_iam_instance_profile" "starbucks_policy_instance_profile" {
  name = "starbucks_policy-Profile"
  role = aws_iam_role.Starbucks_jenkins_policy.name
}

resource "aws_instance" "terrabox" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = "MYLABKEY" # Change key name as per your setup
  vpc_security_group_ids = [aws_security_group.TerraBox.id]
  iam_instance_profile   = aws_iam_instance_profile.starbucks_policy_instance_profile.name
  user_data              = templatefile("./terrabox_install.sh", {})

  tags = {
    Name = "terrabox-SVR"
  }

  root_block_device {
    volume_size = 35
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "high_cpu_utilization"
  alarm_description   = "This alarm monitors high CPU utilization"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 20
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = aws_instance.terrabox.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "High CPU alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "akwonderworld@gmail.com" # Replace with your email address
}


#   # Copy the folder after the instance is created and SSH is available
#   provisioner "file" {
#     source      = "k8s_setup_file"
#     destination = "/home/ubuntu/k8s_setup_file"

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("MYLABKEY.pem")
#       host        = self.public_ip
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chown -R ubuntu:ubuntu /home/ubuntu/k8s_setup_file"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("MYLABKEY.pem")
#       host        = self.public_ip
#     }
#   }
# }


resource "aws_security_group" "TerraBox" {
  name        = "terra-VM-SG"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = toset([22, 25, 80, 443, 6443, 465, 27017])
    content {
      description = "inbound rule for port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Custom TCP Port Range"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Port Range 30000 to 32767"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terra-VM-SG"
  }
}

output "instance_ip" {
  value = aws_instance.terrabox.public_ip
}
