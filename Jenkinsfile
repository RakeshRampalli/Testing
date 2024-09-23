pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
        DOCKER_IMAGE_NAME = 'rakeshrampalli/testing' // Adjust based on your naming preference
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/RakeshRampalli/Testing-.git'
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    sh """
                    mvn sonar:sonar \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh "docker login -u rakeshrampalli -p <your_docker_password>" // Use your actual Docker Hub password
                    sh "docker push ${DOCKER_IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    kubectl apply -f - <<EOF
                    apiVersion: apps/v1
                    kind: Deployment
                    metadata:
                      name: Testing
                    spec:
                      replicas: 1
                      selector:
                        matchLabels:
                          app: testing
                      template:
                        metadata:
                          labels:
                            app: testing
                        spec:
                          containers:
                          - name: testing
                            image: ${DOCKER_IMAGE_NAME}:latest
                            ports:
                            - containerPort: 8080
                    EOF
                    """
                }
            }
        }
    }
}
