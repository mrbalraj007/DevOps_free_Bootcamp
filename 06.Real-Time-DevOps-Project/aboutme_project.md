#### Deploying a YouTube Clone App with DevSecOps & DevOps tools like Jenkins Shared Library Using Docker and Kubernetes.

This blog will help you set up a secure DevSecOps pipeline for your project. Using tools like Kubernetes, Docker, SonarQube, Trivy, OWASP Dependency Check, Prometheus, Grafana, Jenkins (with a shared library), Splunk, Rapid API, and Slack notifications, we make it easy to create and manage your environment.

Environment Setup:


Step 1: Launch an Ubuntu instance for Jenkins, Trivy, Docker and SonarQube

- I have prepared the Terraform code.

Now, we will configure the Jenkins.
<EC2 Public IP Address:8080>
- To unlock the setup password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
![alt text](/Screenshot_for_project/image-1.png)

![alt text](/Screenshot_for_project/image.png)