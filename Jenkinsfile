pipeline {
    agent any

    stages {
        stage('SCM Checkout') {
            steps {
                retry(3) {
                    git branch: 'main', url: 'https://github.com/ShenanVindinu/Laravel-11-Introduction.git'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t shenanvin/phpapp-cuban:%BUILD_NUMBER% .'
            }
        }
        stage('Login to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'testdockerhubpass', variable: 'my-php-app-pass')]) {
                    bat 'docker login -u shenanvin -p %my-php-app-pass%'
                }
            }
        }
        stage('Push Image') {
            steps {
                bat 'docker push shenanvin/phpapp-cuban:%BUILD_NUMBER%'
            }
        }
    }
    post {
        always {
            bat 'docker logout'
        }
    }
}
