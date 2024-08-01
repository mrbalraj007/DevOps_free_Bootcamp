provider "aws" {
  region = var.region
}

resource "aws_instance" "eks_controller" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  provisioner "file" {
    source      = "create_eks_cluster.sh"
    destination = "/home/ubuntu/create_eks_cluster.sh"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/create_eks_cluster.sh",
      "sudo /home/ubuntu/create_eks_cluster.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "eks-controller"
  }
}
