# <span style="color: Yellow;"> Deploying microservices to a Kubernetes cluster with CI/CD: A Step-by-Step Guide </span>
In this blog post, we’ll walk you through the process of deploying a Kubernetes application using Jenkins. This guide will help you set up a CI/CD pipeline for deploying microservices to a Kubernetes cluster. We’ll cover creating roles, binding them to service accounts, and setting up a Jenkins pipeline for automation.

## <span style="color: Yellow;"> Prerequisites </span>
  
- [x] [Clone repository for terraform code](https://github.com/mrbalraj007/DevOps_free_Bootcamp.git) 
- [x] [App Repo](https://github.com/mrbalraj007/Microservice)
- [x] __Jenkins Installation__: Ensure Jenkins is installed and running.
- [x] __Kubernetes Cluster__: Have a Kubernetes cluster set up and accessible.
- [x] __Kubernetes CLI (kubectl)__: Install and configure kubectl on your system.
- [x] __Jenkins Kubernetes Plugin__: Install the Kubernetes plugin for Jenkins to enable Kubernetes integration.
- [x] __Service Account__: Create a Kubernetes service account with appropriate roles and permissions.
- [x] __Token Generation__: Generate a token for the service account to be used by Jenkins for authentication.

## <span style="color: Yellow;"> Key Takeaways
- __Automation__: The pipeline automates the deployment process, making it easier to manage multiple microservices.
- __Flexibility__: The use of Jenkins and Kubernetes allows for flexible and scalable deployment strategies.
- __Efficiency__: Implementing automated CI/CD pipelines improves deployment speed and reliability.
## <span style="color: Yellow;"> What to Avoid
- __Hardcoding Secrets__: Avoid hardcoding sensitive information like tokens in your pipeline scripts. Use Jenkins credentials and Kubernetes secrets.
- __Long Sleep Periods__: Instead of using long sleep periods in your pipeline, consider using appropriate Kubernetes checks to confirm the status of deployments.
## <span style="color: Yellow;"> Key Benefits
- __Streamlined Deployment__: Automates the deployment of multiple microservices with minimal manual intervention.
- __Improved Efficiency__: Reduces deployment time and ensures consistency across environments.
- __Scalability__: Easily scales to handle large numbers of microservices and complex deployment scenarios.


## <span style="color: Yellow;"> Key Points
- __Create a Kubernetes Role__: Define permissions for resources.
- __Bind Role to Service Account__: Assign permissions to the service account.
- __Generate and Use a Token__: Authenticate the service account.
- __Set Up Jenkins Pipeline__: Automate deployment and verification.
  
### <span style="color: cyan;"> Creating the Role and Role Binding:</span>
<span style="color: Yellow;"> 1. Creating a Kubernetes Role</span>

To start, you'll need to define a role in Kubernetes that specifies the permissions for the resources you'll manage. Here's how to do it:

Create a YAML File: Define the role with necessary permissions (e.g., get, list, watch, create, update, patch, delete).

We start by defining a Kubernetes Role with specific permissions using a YAML file.

- Create a role.yaml file to specify what resources the role can access and what actions it can perform (e.g., ```list, create, delete```).
-  Apply this configuration with ```kubectl apply -f role.yaml```.

### <span style="color: cyan;"> Assigning the Role to a Service Account:

- We need to bind the created role to a service account using RoleBinding.
- Create a ```bind.yaml``` file to link the role with the service account.
- Apply this configuration with ```kubectl apply -f bind.yaml```.

### <span style="color: cyan;"> Creating a Token for Authentication:

- Generate a token for the service account to authenticate with Kubernetes.
- Use a YAML file to create a Kubernetes Secret that stores the token.
- Apply this configuration with kubectl apply -f secret.yaml.
- Retrieve the token using ```kubectl describe secret <secret-name> -n web-apps```.

## <span style="color: Cyan;"> Setting Up Jenkins Pipeline:

- Create a Jenkins pipeline to handle the deployment process.
- Define the pipeline stages: deploy to Kubernetes and verify deployment.
- Configure Jenkins to use the service account token for Kubernetes API interactions.
- Use the pipeline syntax to apply Kubernetes configurations and monitor the deployment.
  
<span style="color: Yellow;"> 4. Setting Up Jenkins Pipeline
Finally, set up a Jenkins pipeline to automate deployment:

Create a Jenkins Pipeline: Define stages for deployment and verification.

Commit and Run: Commit the Jenkinsfile and let Jenkins pick it up. Monitor the deployment process and check the application URL once it’s up and running.


## <span style="color: Yellow;"> Deployment and Cleanup:

- Once the pipeline is set up, Jenkins will deploy the microservices and provide a URL to access the application.
- To clean up, delete the Kubernetes cluster with ```eksctl delete cluster --name <cluster-name> --region <region>```.
***********************




<span style="color: Yellow;"> Conclusion

By following these steps and best practices, you can efficiently set up a CI/CD pipeline that enhances your deployment processes and streamlines your workflow.

Following these steps, you can successfully deploy and manage a Kubernetes application using Jenkins. Automating this process with Jenkins pipelines ensures consistent and reliable deployments.
If you found this guide helpful, please like and subscribe to my blog for more content. Feel free to reach out if you have any questions or need further assistance!

Ref Link

- [YouTube Link](https://www.youtube.com/watch?v=SO3XIJCtmNs&t=498s "11 Microservice CICD Pipeline DevOps Project | Ultimate DevOps Pipeline")
- []()





