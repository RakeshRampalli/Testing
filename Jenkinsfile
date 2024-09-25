pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Docker Hub credentials in Jenkins
        DOCKER_IMAGE_NAME = 'rakeshrampalli/testing:latest'
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
        K8S_CREDENTIALS_ID = 'k8s-credentials' // Kubernetes token in Jenkins
        KUBERNETES_CLUSTER = 'minikube' // Set your Kubernetes cluster name here (e.g., minikube)
        KUBERNETES_NAMESPACE = 'default' // Kubernetes namespace to use
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/RakeshRampalli/Testing.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh """
                mvn sonar:sonar \
                -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                -Dsonar.host.url=${SONAR_HOST_URL} \
                -Dsonar.login=${SONAR_AUTH_TOKEN}
                """
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE_NAME} ."
            }
        }

        stage('Docker Push') {
            steps {
                script {
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
                    // Use Jenkins credentials for the Kubernetes token
                    withCredentials([string(credentialsId: K8S_CREDENTIALS_ID, variable: 'K8S_TOKEN')]) {
                        sh '''
                        kubectl config set-credentials my-user --token=$K8S_TOKEN
                        kubectl config set-context $KUBERNETES_CLUSTER --cluster=minikube --namespace=$KUBERNETES_NAMESPACE --user=my-user
                        kubectl config use-context $KUBERNETES_CLUSTER
                        kubectl apply -f k8s/deployment.yaml --validate=false
                        kubectl apply -f k8s/service.yaml --validate=false
                        '''
                    }
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
