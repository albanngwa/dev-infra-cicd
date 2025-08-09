pipeline {
    agent any

    environment {
        TF_WORKING_DIR = 'terraform/infra'
        AWS_DEFAULT_REGION = 'us-east-2'
    }

    options {
        skipStagesAfterUnstable()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    echo 'AWS credentials have been set in the environment'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'ls -la'
                    sh 'terraform init'
                }
            }
        }

        stage('Validate & Format') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform validate'
                    sh 'terraform fmt -recursive'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    dir("${TF_WORKING_DIR}") {
                        sh 'terraform plan -var-file=terraform.tfvars'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    input message: 'Approve Terraform Apply?', ok: 'Apply'
                    dir("${TF_WORKING_DIR}") {
                        sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline complete.'
        }
        success {
            echo 'Terraform apply succeeded'
        }
        failure {
            echo 'Terraform apply failed'
        }
    }
}
