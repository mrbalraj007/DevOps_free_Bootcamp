# outputs.tf

# Output the Jenkins Access Details
output "jenkins_access" {
  description = "Access details for Jenkins"
  value = {
    url       = "http://${aws_instance.jenkins.public_ip}:8080"
    public_ip = aws_instance.jenkins.public_ip
  }
}

# Output the initial Jenkins admin password file path
output "jenkins_initial_password_path" {
  description = "Path to the Jenkins initial admin password file on the instance"
  value       = "/home/ubuntu/jenkins_initial_password.txt"
}
