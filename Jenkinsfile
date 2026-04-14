pipeline {
    agent any

    options {
        timeout(time: 15, unit: 'MINUTES')
    }

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

        stage('Update Kubernetes Manifest') {
            steps {
                dir('kubernetes') {
                    sh '''
                    # Replace IMAGE_TAG with build number
                    sed -i "s|IMAGE_TAG|$TAG|g" deployment.yaml
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                dir('kubernetes') {
                    sh '''
                    # Clean old broken resources
                    kubectl delete deployment app-deployment || true
                    kubectl delete service trend-service || true

                    # Apply new configs
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml

                    # Force correct image (extra safety)
                    kubectl set image deployment/app-deployment trend-container=$IMAGE_NAME:$TAG

                    # Check rollout (with timeout)
                    kubectl rollout status deployment/app-deployment --timeout=120s
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get pods -l app=trend
                kubectl get svc trend-service
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''
                # Safe cleanup (do NOT delete all images)
                docker image prune -f
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
