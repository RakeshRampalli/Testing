pipeline {
    agent any

    environment {
        // Define Docker Hub credentials and image name
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Jenkins credentials ID for Docker Hub
        DOCKER_IMAGE_NAME = 'rakeshrampalli/testing' // Change to your Docker Hub username
        SONARQUBE_SERVER = 'http://your-sonarqube-server:9000' // Replace with your SonarQube server URL
        SONARQUBE_CREDENTIALS_ID = 'sonarqube-credentials' // Jenkins credentials ID for SonarQube
    }

    stages {
        stage('Checkout') {
            steps {
                // Check out code from your GitHub repository
                git branch: 'main', url: 'https://github.com/RakeshRampalli/Testing.git'
            }
        }

        stage('Build') {
            steps {
                // Build the project using Maven
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    withCredentials([usernamePassword(credentialsId: SONARQUBE_CREDENTIALS_ID, usernameVariable: 'SONAR_USER', passwordVariable: 'SONAR_PASS')]) {
                        sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=your-project-key \
                        -Dsonar.host.url=${SONARQUBE_SERVER} \
                        -Dsonar.login=${SONAR_USER} \
                        -Dsonar.password=${SONAR_PASS}
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    def image = docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        // Push the Docker image
                        image.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy the Docker image to Kubernetes
                    sh """
                    kubectl set image deployment/your-deployment-name your-container-name=${DOCKER_IMAGE_NAME}:latest
                    kubectl rollout status deployment/your-deployment-name
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image built, pushed, deployed, and SonarQube analysis completed successfully!'
        }
        failure {
            echo 'Pipeline failed at some stage.'
        }
    }
}
