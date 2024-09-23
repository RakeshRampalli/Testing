pipeline {
    agent any

    environment {
        // SonarQube details
        SONAR_PROJECT_KEY = 'TestingApp'
        SONAR_HOST_URL = 'http://192.168.41.130:9000'
        SONAR_AUTH_TOKEN = 'sqa_37a008949cf733aba26bbfe6309fef3b2d2005de'

        // Maven settings
        MAVEN_OPTS = '-Xmx1024m'  // Optional: Set Maven memory options
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository
                git branch: 'main', url: 'https://github.com/RakeshRampalli/Testing.git'
            }
        }

        stage('Maven Build') {
            steps {
                // Clean and build the Maven project
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Run SonarQube analysis using Maven
                withSonarQubeEnv('SonarQube') {  // Ensure 'SonarQube' is configured in Jenkins
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
                // Wait for SonarQube Quality Gate results and abort if it fails
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy') {
            steps {
                // Define deployment steps here. Example: deploy to a Tomcat server.
                // Update this part as per your deployment needs.
                echo 'Deploying the application...'
                // Example: sh 'scp target/your-app.war user@server:/path/to/deployment'
            }
        }
    }

    post {
        success {
            echo 'Build, SonarQube analysis, and deployment completed successfully!'
        }
        failure {
            echo 'Build failed, or quality gate did not pass.'
        }
    }
}

