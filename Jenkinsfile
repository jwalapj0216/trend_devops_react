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
                # Delete old resources to avoid immutable errors
                kubectl delete deployment app-deployment || true
                kubectl delete service trend-service || true

                # Apply new deployment
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''
            }
        }
    }

    stage('Cleanup') {
        steps {
            sh '''
            # Clean Docker to avoid EC2 crash
            docker system prune -af
            docker builder prune -af
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

