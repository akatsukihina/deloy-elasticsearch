pipeline {
    agent {
    node {
        label 'agent-build'
        customWorkspace "/home/vipa/workspace/${JOB_NAME}"
    }
    }

    options {
        skipDefaultCheckout()
    }

    environment {
        REGISTRY        = 'docker.io'
        IMAGE_NAME      = 'akatsukihina/ansible/elasticsearch-setup'
        IMAGE_TAG       = "v1.0.${BUILD_NUMBER}"
        GIT_REPO        = 'https://github.com/akatsukihina/deloy-elasticsearch.git'
        GIT_CREDENTIAL  = 'git-es-pass'
        REG_CREDENTIAL  = 'registry'
    }

    stages {

        stage('Force Clean Workspace') {
            steps {
                sh '''
                    echo "Cleaning workspace..."
                    rm -rf * .git || true
                '''
            }
        }

        stage('Checkout source from GitLab') {
            steps {
                git branch: 'main',
                    credentialsId: "${GIT_CREDENTIAL}",
                    url: "${GIT_REPO}"
            }
        }

        stage('Login Registry') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${REG_CREDENTIAL}",
                        usernameVariable: 'REG_USER',
                        passwordVariable: 'REG_PASS'
                    )
                ]) {
                    sh '''
                        echo "$REG_PASS" | docker login ${REGISTRY} \
                          -u "$REG_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    docker build \
                      -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} \
                      .
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        cleanup {
            sh '''
                docker logout ${REGISTRY} || true
                docker image prune -f || true
            '''
        }
    }
}