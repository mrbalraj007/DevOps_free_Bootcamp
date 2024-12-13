```sh
pipeline {
    agent any

    parameters {
        string(name: 'ECR_REPO_NAME', defaultValue: 'amazon-prime', description: 'Enter repository name')
        string(name: 'AWS_ACCOUNT_ID', defaultValue: 'xxxxxxxxxxxxx', description: 'Enter AWS Account ID')
    }

    tools {
        jdk 'JDK'
        nodejs 'NodeJS'
    }

    environment {
        SCANNER_HOME = tool 'SonarQube Scanner'
    }

    stages {
        stage('01. Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mrbalraj007/Amazon-Prime-Clone-Project.git'
            }
        }
        stage('02. SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectName=${params.ECR_REPO_NAME.toLowerCase()} \
                    -Dsonar.projectKey=${params.ECR_REPO_NAME.toLowerCase()}
                    """
                }
            }
        }
        stage('03. SonarQube Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
            }
        }
        stage('04. Install npm') {
            steps {
                sh "npm install"
            }
        }
        stage('05. Trivy File Scan') {
            steps {
                sh "trivy fs . > trivy-scan-results.txt"
            }
        }
        stage('06. Docker Image Build') {
            steps {
                sh "docker build -t ${params.ECR_REPO_NAME.toLowerCase()} ."
            }
        }
        stage('07. Create ECR Repo') {
            steps {
                withCredentials([string(credentialsId: 'access-key', variable: 'AWS_ACCESS_KEY'), string(credentialsId: 'secret-key', variable: 'AWS_SECRET_KEY')]) {
                    sh """
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY
                    aws configure set aws_secret_access_key $AWS_SECRET_KEY
                    aws ecr describe-repositories --repository-names ${params.ECR_REPO_NAME.toLowerCase()} --region us-east-1 || \
                    aws ecr create-repository --repository-name ${params.ECR_REPO_NAME.toLowerCase()} --region us-east-1
                    """
                }
            }
        }
        stage('08. Login to ECR & tag image') {
            steps {
                withCredentials([string(credentialsId: 'access-key', variable: 'AWS_ACCESS_KEY'), string(credentialsId: 'secret-key', variable: 'AWS_SECRET_KEY')]) {
                    sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
                    docker tag ${params.ECR_REPO_NAME.toLowerCase()} ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${params.ECR_REPO_NAME.toLowerCase()}:${BUILD_NUMBER}
                    docker tag ${params.ECR_REPO_NAME.toLowerCase()} ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${params.ECR_REPO_NAME.toLowerCase()}:latest
                    """
                }
            }
        }
        stage('09. Push image to ECR') {
            steps {
                withCredentials([string(credentialsId: 'access-key', variable: 'AWS_ACCESS_KEY'), string(credentialsId: 'secret-key', variable: 'AWS_SECRET_KEY')]) {
                    sh """
                    docker push ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${params.ECR_REPO_NAME.toLowerCase()}:${BUILD_NUMBER}
                    docker push ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${params.ECR_REPO_NAME.toLowerCase()}:latest
                    """
                }
            }
        }
        stage('10. Cleanup Images from Jenkins Server') {
            steps {
                sh """
                docker rmi ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${params.ECR_REPO_NAME.toLowerCase()}:${BUILD_NUMBER}
                docker rmi ${params.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${params.ECR_REPO_NAME.toLowerCase()}:latest
                """
            }
        }
        stage('11. Cleanup Old Images from ECR') {
            steps {
                withCredentials([string(credentialsId: 'access-key', variable: 'AWS_ACCESS_KEY'), string(credentialsId: 'secret-key', variable: 'AWS_SECRET_KEY')]) {
                    sh """
                    IMAGES_TO_DELETE=\$(aws ecr list-images --repository-name ${params.ECR_REPO_NAME.toLowerCase()} --region us-east-1 --query 'imageIds[0:-3]' --output json)
                    if [ "\$IMAGES_TO_DELETE" != "[]" ]; then
                        aws ecr batch-delete-image --repository-name ${params.ECR_REPO_NAME.toLowerCase()} --region us-east-1 --image-ids "\$IMAGES_TO_DELETE"
                    fi
                    """
                }
            }
        }
        stage('12. Delete Local Docker Images') {
            steps {
                sh """
                docker images --format '{{.Repository}}:{{.Tag}}' | grep '^${params.ECR_REPO_NAME.toLowerCase()}' | awk '{print \$1}' | xargs -r docker rmi
                """
            }
        }
    }
}
```