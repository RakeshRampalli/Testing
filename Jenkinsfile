pipeline {
    agent any

    environment {
        // SonarQube details
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'
        
        // Tomcat server details
        TOMCAT_USER = 'tomcat'  // Replace with your Tomcat username
        TOMCAT_PASS = 's3cret'  // Replace with your Tomcat password
        TOMCAT_URL = 'http://192.168.41.130:9090'  // Tomcat server URL
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
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

        stage('Quality Gate') {
            steps {
                // Wait for SonarQube Quality Gate result
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                // Deploy WAR to Tomcat server
                script {
                    def warFile = 'target/your-app.war' // Update with the actual WAR file name
                    sh """
                    curl --user ${TOMCAT_USER}:${TOMCAT_PASS} --upload-file ${warFile} \
                        ${TOMCAT_URL}/manager/text/deploy?path=/your-app&update=true
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Build, SonarQube analysis, quality gate check, and deployment completed successfully!'
        }
        failure {
            echo 'Build failed, SonarQube quality gate failed, or deployment failed.'
        }
    }
}
