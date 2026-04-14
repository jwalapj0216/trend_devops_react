pipeline {
    agent any
    
    environment {
        IMAGE_NAME = "jwalapj02/app"
        TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/jwalapj0216/trend_devops_react.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$TAG .
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-cred',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME:$TAG
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                dir('kubernetes') {
                    sh '''
                    # Ensure kubeconfig is correct
                    kubectl get nodes

                    # Apply base manifests (only first time needed)
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml

                    # Update image WITHOUT deleting deployment
                    kubectl set image deployment/app-deployment \
                    trend-container=$IMAGE_NAME:$TAG

                    # Wait for rollout to complete
                    kubectl rollout status deployment/app-deployment
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                # Clean only unused images (not everything)
                docker image prune -af
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

