pipeline {
    agent any

    environment {
        // Define SonarQube details
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
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
                // Run SonarQube analysis
                withSonarQubeEnv('SonarQube') { // 'SonarQube' is the name of your SonarQube server configuration in Jenkins
                    sh """
                    mvn sonar:sonar \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                // Deployment step
                echo 'Deploying the application...'
                // You can add your deployment script here. 
                // For example, deploying to a server using SCP or running deployment scripts.
            }
        }
    }

    post {
        success {
            echo 'Build, SonarQube analysis, and deployment completed successfully!'
        }
        failure {
            echo 'Build failed or deployment failed.'
        }
    }
}
