pipeline{
    agent any


    parameters {
        string(name: 'GIT_REPO' , defaultValue: 'git@github.com:zoglobek/devops_endgame.git', description: 'Git repository URL')
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build')
        string(name: 'IMAGE_NAME', defaultValue: 'galnewman/test', description: 'Docker image name')
        string(name: 'DOCKER_TAG' , defaultValue: 'latest', description: 'Docker tag')
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Environment Selection')
        choice(name: 'Cleanup', choices: ['yes', 'no'], description: 'work space cleanup')
        

    }
    environment {
        DOCKER_CREDS = credentials('jenkins_docker')
        GIT_CREDS = credentials('jengitkey')
    }
    stages{
        stage('Workspace Cleanup') {
                when {
                    expression { params.Cleanup == 'yes' }
                }
                steps {
                    cleanWs()
                }
            }
        stage('show build parameters') {
            steps {
            echo "Webhook triggered build"
            echo "Build triggered at: $(date)" 
            echo "Branch is: $GIT_BRANCH"
            echo "Commit is: $GIT_COMMIT"
            }
        }
    
    stages{
        stage('pull git files for docker build'){
            steps{
                git url: "${params.GIT_REPO}", branch: "${params.BRANCH}", credentialsId: 'jengitkey'
            }
        }
        stage('validate files') {
            steps {
                sh 'ls -la'
                sh 'cat Dockerfile'
                sh 'pwd'
            }
        }
        stage('Trivy Scan') {
            steps {
                sh '''
                trivy fs  --exit-code 1 --severity "HIGH,CRITICAL" ./app
                '''
            }
        }
        stage('build docker image') {
            steps {
                sh "docker build -t ${params.IMAGE_NAME}:${params.DOCKER_TAG} ."
            }
        }
        stage('Trivy image scan') {
            steps {
                sh """
                trivy image --exit-code 1 --severity "HIGH,CRITICAL" ${params.IMAGE_NAME}:${params.DOCKER_TAG}
                """
            }
        }
        stage('Docker Login') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                }
            }
        stage('Push Docker Image') {
            steps {
                sh "docker push ${params.IMAGE_NAME}:${params.DOCKER_TAG}"
            }
        }
    
    }
}