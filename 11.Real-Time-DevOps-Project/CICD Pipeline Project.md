# <span style="color: Yellow;"> Creating a Starbucks Clone on AWS: A Comprehensive DevSecOps Guide</span>

In this blog, we’ll walk you through deploying a Starbucks clone on AWS using a DevSecOps approach. This process integrates development, security, and operations practices to ensure a smooth and secure deployment. We’ll cover the key steps, technologies used, and how to troubleshoot common issues.

## <span style="color: Yellow;"> Prerequisites for This Project </span>
 
Before you start, ensure you have the following:
- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp/tree/main/09.Real-Time-DevOps-Project/Terraform_Code/04.Code_IAC_Terraform_box) 
- [x] [App Code Repo](https://github.com/mrbalraj007/starbucks/tree/main)
- [x] AWS Account: Set up an account to manage resources and services.
- [x] Jenkins Installed: Ensure Jenkins is configured and running for CI/CD processes.
- [x] Docker: Install Docker and Docker Scout for building and scanning Docker images.
- [x] AWS Services: Configure AWS CloudWatch for monitoring and SNS for notifications.
- [x] SonarQube: Install and configure SonarQube for code quality analysis.
- [x] OWASP Dependency-Check: Install for vulnerability scanning of project dependencies.



## <span style="color: Yellow;"> Technologies Used:</span>
- __Jenkins__: Automation server for building, testing, and deploying code.
- __Docker__: Container platform for building and running applications.
- __Docker Hub__: Repository for storing and sharing Docker images.
- __CloudWatch__: AWS service for monitoring and managing cloud resources.
- __SNS (Simple Notification Service)__: AWS service for sending notifications.
- __SonarQube__: Code quality and security analysis tool.
- __OWASP Dependency-Check__: Tool for identifying vulnerabilities in project dependencies.
- __[Docker Scout](https://earthly.dev/blog/docker-scout/, 'What Is Docker Scout and How to Use It')__: Tool for scanning Docker images for security vulnerabilities.



```bash
ubuntu@ip-172-31-95-197:~$ jenkins --version
2.462.2

ubuntu@ip-172-31-95-197:~$ trivy --version
Version: 0.55.0

ubuntu@ip-172-31-95-197:~$ docker --version
Docker version 24.0.7, build 24.0.7-0ubuntu4.1

ubuntu@ip-172-31-95-197:~$ docker-scout version

      ⢀⢀⢀             ⣀⣀⡤⣔⢖⣖⢽⢝
   ⡠⡢⡣⡣⡣⡣⡣⡣⡢⡀    ⢀⣠⢴⡲⣫⡺⣜⢞⢮⡳⡵⡹⡅
  ⡜⡜⡜⡜⡜⡜⠜⠈⠈        ⠁⠙⠮⣺⡪⡯⣺⡪⡯⣺
 ⢘⢜⢜⢜⢜⠜               ⠈⠪⡳⡵⣹⡪⠇
 ⠨⡪⡪⡪⠂    ⢀⡤⣖⢽⡹⣝⡝⣖⢤⡀    ⠘⢝⢮⡚       _____                 _
  ⠱⡱⠁    ⡴⡫⣞⢮⡳⣝⢮⡺⣪⡳⣝⢦    ⠘⡵⠁      / ____| Docker        | |
   ⠁    ⣸⢝⣕⢗⡵⣝⢮⡳⣝⢮⡺⣪⡳⣣    ⠁      | (___   ___ ___  _   _| |_
        ⣗⣝⢮⡳⣝⢮⡳⣝⢮⡳⣝⢮⢮⡳            \___ \ / __/ _ \| | | | __|
   ⢀    ⢱⡳⡵⣹⡪⡳⣝⢮⡳⣝⢮⡳⡣⡏    ⡀       ____) | (_| (_) | |_| | |_
  ⢀⢾⠄    ⠫⣞⢮⡺⣝⢮⡳⣝⢮⡳⣝⠝    ⢠⢣⢂     |_____/ \___\___/ \__,_|\__|
  ⡼⣕⢗⡄    ⠈⠓⠝⢮⡳⣝⠮⠳⠙     ⢠⢢⢣⢣
 ⢰⡫⡮⡳⣝⢦⡀              ⢀⢔⢕⢕⢕⢕⠅
 ⡯⣎⢯⡺⣪⡳⣝⢖⣄⣀        ⡀⡠⡢⡣⡣⡣⡣⡣⡃
⢸⢝⢮⡳⣝⢮⡺⣪⡳⠕⠗⠉⠁    ⠘⠜⡜⡜⡜⡜⡜⡜⠜⠈
⡯⡳⠳⠝⠊⠓⠉             ⠈⠈⠈⠈



version: v1.13.0 (go1.22.5 - linux/amd64)
git commit: 7a85bab58d5c36a7ab08cd11ff574717f5de3ec2
ubuntu@ip-172-31-95-197:~$
```



## <span style="color: Yellow;"> Key Takeaways:
- Automated CI/CD Pipeline: Automating the build, test, and deployment process improves efficiency and reduces manual intervention.
- Error Handling: Ensure all required tools and configurations are in place to avoid build failures.
- Monitoring and Alerts: Utilize CloudWatch and SNS to monitor system performance and receive timely notifications.
- Enhanced Security: Integration of OWASP, Docker Scout, and Dependency-Check ensures a secure deployment pipeline.
- Code Quality: SonarQube helps maintain high code quality standards.



## <span style="color: Yellow;"> What to Avoid:
- Skipping Security Scans: Always include security scans to identify and mitigate vulnerabilities.
- Ignoring Resource Monitoring: Regularly check resource utilization to prevent potential issues.
Overlooking Dependency Management: Regularly update and check dependencies for vulnerabilities.


## <span style="color: Yellow;"> Key Benefits:
- *Efficiency: Automating pipeline stages saves time and reduces manual errors*.
- *Security: Regular scans with Docker Scout and OWASP Dependency-Check help identify and fix vulnerabilities*.
- *Reliability: Continuous integration and deployment ensure consistent and reliable application updates.*


## <span style="color: Yellow;"> Why Use This Project:
- *Deploying a Starbucks clone using this approach not only demonstrates practical skills in integrating various DevSecOps tools but also highlights the importance of security and efficiency in modern software deployment. It showcases how to build, test, and deploy applications securely and efficiently, leveraging cloud services and CI/CD practices.*

## <span style="color: Yellow;"> Use Case:
- *This setup is ideal for development teams looking to implement a robust CI/CD pipeline to automate their build, test, and deployment processes. It ensures high-quality code delivery with continuous monitoring and security checks.*


__Ref Link__

- [YouTube Link](https://www.youtube.com/watch?v=N_AEbtTLcgY&list=PLJcpyd04zn7rZtWrpoLrnzuDZ2zjmsMjz&index=77 "Deploy Starbucks Clone on AWS Using a DevSecOps Approach | Complete Guide")
- [Docker Scout](https://docs.docker.com/scout/)
- [What Is Docker Scout and How to Use It](https://earthly.dev/blog/docker-scout/)





