pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
    }

    stages {
        stage('Clone Git') {
            steps {
                git branch: 'main', url: 'https://github.com/RakeshRampalli/Testing.git'
            }
        }

        stage('Build Maven Project') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
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
                    sh 'docker build -t rakeshrampalli/testing:latest .'
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker push rakeshrampalli/testing:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    kubectl apply -f k8s/deployment.yaml
                    """
                }
            }
        }
    }
}
