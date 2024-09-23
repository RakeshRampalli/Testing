pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'rakeshrampalli/testing'
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
        K8S_DEPLOYMENT_NAME = 'your-deployment-name' // Change this to your Kubernetes deployment name
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo-url' // Replace with your Git repository URL
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarQubeScanner' // Adjust if needed
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                        sh "${scannerHome}/bin/sonar-scanner " +
                        "-Dsonar.projectKey=${SONAR_PROJECT_KEY} " +
                        "-Dsonar.host.url=${SONAR_HOST_URL} " +
                        "-Dsonar.login=${SONAR_AUTH_TOKEN} " +
                        "-Dsonar.sources=."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE_NAME}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Assuming you have kubectl configured with your cluster context
                    sh "kubectl set image deployment/${K8S_DEPLOYMENT_NAME} ${K8S_DEPLOYMENT_NAME}=${DOCKER_IMAGE_NAME} --record"
                }
            }
        }
    }
}
