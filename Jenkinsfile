pipeline{
    agent any


    parameters {
        string(name: 'GIT_REPO' , defaultValue: 'git@github.com:zoglobek/devops_endgame.git', description: 'Git repository URL')
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build')
        string(name: 'IMAGE_NAME', defaultValue: 'galnewman/IMAGE_NAMES', description: 'Docker image name')
        string(name: 'DOCKER_TAG' , defaultValue: 'latest', description: 'Docker tag')
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Environment Selection')
        

    }
    environment {
        DOCKER_CREDS = credentials('jenkins_docker')
        GIT_CREDS = credentials('jengitkey')
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
        stage('build docker image') {
            steps {
                sh "docker build -t ${params.IMAGE_NAME}:${params.DOCKER_TAG} ."
            }
        }
    }
}