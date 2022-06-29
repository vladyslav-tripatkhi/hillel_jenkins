def image_name = "jenkins"

pipeline {
    agent any

    environment {
        MY_ENV = "test env 01"
        REGISTRY_NAME = "${params.AWS_ACCOUNT}.dkr.ecr.${params.AWS_REGION}.amazonaws.com"
    }

    parameters {
        string(
            name: 'IMAGE_NAME',
            defaultValue: image_name,
            description: 'Image name'
        )
        
        choice(
            name: "AWS_REGION",
            choices: ["us-east-1", "us-west-1"],
            description: "AWS region name",
        )
        
        string(
            name: "AWS_ACCOUNT",
            defaultValue: "507676015690",
            description: 'AWS_ACCOUNT_ID'
        )
    }

    stages {
        stage("Pre-check") {
            steps {
                script {
                    image_name = "jenkins"
                    if (!params.IMAGE_NAME.isEmpty()) {
                        image_name = params.IMAGE_NAME
                    }
                }
            }
        }
        
        stage("SCM") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[
                        name: '*/master'
                    ]], 
                    userRemoteConfigs: [[
                        credentialsId: 'ssh-test',
                        url: 'git@github.com:vladyslav-tripatkhi/hillel_jenkins.git'
                    ]]
                ])
            }
        }

        stage("Build") {
            steps {
                echo "Building; Build ID: ${env.BUILD_ID}"
                // sh "docker build -t ${params.IMAGE_NAME}:${env.BUILD_ID} ."
                script {
                    my_tmp_var = "Hello! ${env.MY_ENV}"
                    docker.build("${env.REGISTRY_NAME}/${image_name}:lts-slim")
                }

                echo "Hello from ${my_tmp_var}"
            }
        }

        stage("Push") {
            steps {
                script {
                    echo "Deploying ${env.MY_ENV} to us-east-1"
                    docker.withRegistry("https://${env.REGISTRY_NAME}", "ecr:us-east-1:jenkins-ecr-role") {
                        docker.image("${env.REGISTRY_NAME}/${image_name}:lts-slim").push()
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}