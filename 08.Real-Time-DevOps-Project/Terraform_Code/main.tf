resource "null_resource" "Code_IAC_Jenkins_Trivy" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Jenkins_Trivy_Docker && terraform init && terraform apply -auto-approve"
    command = "cd 01.Code_IAC_Jenkins_Trivy && terraform init && terraform apply -auto-approve"
  }
}

resource "null_resource" "Code_IAC_Nexus" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd 02.Code_IAC_Nexus && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC_Jenkins_Trivy]
}

resource "null_resource" "Code_IAC_SonarQube" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd 03.Code_IAC_SonarQube && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC_Nexus]
}

resource "null_resource" "Code_IAC_Terraform_box" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd 04.Code_IAC_Terraform_box && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC_SonarQube]
}

resource "null_resource" "Code_IAC_Grafana" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd 05.Code_IAC_Grafana && terraform init && terraform apply -auto-approve"
  }
  depends_on = [null_resource.Code_IAC_Terraform_box]
}
