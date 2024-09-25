pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Docker Hub credentials in Jenkins
        DOCKER_IMAGE_NAME = 'rakeshrampalli/testing:latest'
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
        K8S_CREDENTIALS_ID = 'k8s-credentials' // Kubernetes token in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git branch: 'main', url: 'https://github.com/RakeshRampalli/Testing.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Clean and package the application
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    sh """
                    mvn sonar:sonar \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.host.url=${SONAR_HOST_URL} \
                    -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE_NAME} ."
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        sh "docker push ${DOCKER_IMAGE_NAME}"
                    }
                }
            }
        }

       stage('Deploy to Kubernetes') {
    steps {
        script {
            // Use Jenkins credentials to handle the kubeconfig file
            withCredentials([file(credentialsId: K8S_CREDENTIALS_ID, variable: 'KUBECONFIG_FILE')]) {
                // Set the KUBECONFIG environment variable to use the kubeconfig file
                sh '''
                echo "Using KUBECONFIG_FILE: $KUBECONFIG_FILE"
                echo "K8S_TOKEN: $K8S_TOKEN"

                export KUBECONFIG=$KUBECONFIG_FILE
                kubectl config set-credentials my-user --token=${K8S_TOKEN}
                kubectl apply -f k8s/deployment.yaml --validate=false
                kubectl apply -f k8s/service.yaml --validate=false
                '''
            }
        }
    }
}

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}
