resource "null_resource" "HA_proxy_LB" {
  provisioner "local-exec" {
    #command = "cd ../folderPath && terraform init && terraform apply -auto-approve"
    command = "cd HA_proxy_LB && terraform init && terraform apply -auto-approve"
  }
}

resource "null_resource" "Master_Worker_Setup" {
  provisioner "local-exec" {
    #command = "cd ../folderPath && terraform init && terraform apply -auto-approve"
    command = "cd Master_Worker_Setup && terraform init && terraform apply -auto-approve"
  }

  depends_on = [null_resource.HA_proxy_LB]
}
