#### Deploying a YouTube Clone App with DevSecOps & DevOps tools like Jenkins Shared Library Using Docker and Kubernetes.

This blog will help you set up a secure DevSecOps pipeline for your project. Using tools like Kubernetes, Docker, SonarQube, Trivy, OWASP Dependency Check, Prometheus, Grafana, Jenkins (with a shared library), Splunk, Rapid API, and Slack notifications, we make it easy to create and manage your environment.

Environment Setup:

Step 1: Launch an Ubuntu instance for Jenkins, Trivy, Docker and SonarQube

-I am using Terraform to create a infrastrucutre. I have prepared the Terraform code.
+ clone the [repo[()] where Terraform code is created.
Do the ```ls``` in terminal

```bash
/Terraform_Code (main)
$ ls -l
total 20
drwxr-xr-x 1 bsingh 1049089    0 Jul 28 12:45 Code_IAC_Jenkins_Trivy_Docker/
drwxr-xr-x 1 bsingh 1049089    0 Jul 28 12:47 Code_IAC_Splunk/
-rw-r--r-- 1 bsingh 1049089  632 Jul 28 12:46 main.tf
```
cd Terraform_Code







Now, we will configure the Jenkins.
<EC2 Public IP Address:8080>
- To unlock the setup password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
![Reference Image](/Screenshot_for_project/image-1.png)
![Reference Image](/Screenshot_for_project/image.png)

- Dashboard for Jenkins
![alt text](image-4.png)

Now, we will try to access the SonarQube as it is accessible via 9000, Make sure add 9000 ports in the security group.
![alt text](image-7.png)
```bash
<ec2-public-ip:9000>
```
![alt text](image-5.png)

Dashboard of SonarQube
![alt text](image-6.png)

- Verify the Trivy version on Jenkins machine
```bash
$ trivy --version
Version: 0.53.0
```

+ Configure Splunk





















![alt text](image.png)

Jenkins
![alt text](image-1.png)







Should have an __[rapidapi](https://rapidapi.com/)__ account.

"Once you have an account, your name will automatically appear in Rapid API."
![alt text](image-2.png)


In the search bar, type "YouTube" and choose "YouTube v3."
![alt text](image-3.png)
