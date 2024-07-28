resource "null_resource" "Code_IAC_Jenkins_Trivy_Docker" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Jenkins_Trivy_Docker && terraform init && terraform apply -auto-approve"
    command = "cd Code_IAC_Jenkins_Trivy_Docker && terraform init && terraform apply -auto-approve"
  }
}

resource "null_resource" "Code_IAC_Splunk" {
  provisioner "local-exec" {
    #command = "cd ../Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
    command = "cd Code_IAC_Splunk && terraform init && terraform apply -auto-approve"
  }

  depends_on = [null_resource.Code_IAC_Jenkins_Trivy_Docker]
}
