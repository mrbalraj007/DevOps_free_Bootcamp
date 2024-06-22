# Install SonarQube



![alt text](image.png)

default login credential is ```admin``` 

we will install two plugin (SonarQube Scanner & Eclipse Temurin installer)
![alt text](image-1.png)

- we are configuring it now
> - 01. first we have configure the java
![alt text](image-2.png)
> - 02. configure the sonar scanner
![alt text](image-3.png)
> - 03. configure the maven
![alt text](image-4.png)

will create a pipeline.
![alt text](image-5.png)

will generate the token from SonarQ to configure in Jenkins.
![alt text](image-6.png)

now, we will confiugre it in Jenkins.
![alt text](image-7.png)

Now, we will configure the sonar server
![alt text](image-8.png)




![alt text](image-9.png)

![alt text](image-10.png)


```bash
pipeline {
    agent any
    
    tools {
        maven 'maven3'
        jdk 'jdk17'
    }
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }
    stages {
        stage('Git CheckOut') {
            steps {
                git branch: 'main', url: 'https://github.com/jaiswaladi246/Boardgame'    
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('Sonar') {
            steps {
                withSonarQubeEnv('sonar-server') {
                sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Board -Dsonar.projectkey=Boardkey -Dsonar.java.binaries=target"    
                }
            }
        }
         stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        
        
    }
}

```