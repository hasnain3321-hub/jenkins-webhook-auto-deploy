pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'bash scripts/test.sh'
            }
        }

        stage('Docker Build & Deploy') {
            steps {
                sh 'bash scripts/deploy.sh'
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                  curl -fsS http://127.0.0.1:8082/ \
                    | grep -q "Deployment Successful"
                  echo "Application is healthy"
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check console logs.'
        }
    }
}
