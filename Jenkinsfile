pipeline {
    agent any

    environment {
        TF_DIR = 'terraform'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch 'main' url: 'https://github.com/albanngwa/dev-infra-cicd.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Validate & Format') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                    sh 'terraform fmt -check'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
              terraform plan \
                -var="region=us-east-2"
            '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    runTerraformApply()
                }
            }
        }
    }
}

/* groovylint-disable-next-line MethodReturnTypeRequired, NoDef */
def runTerraformApply() {
    dir("${TF_DIR}") {
        withCredentials([
      usernamePassword(
        credentialsId: 'aws-creds',
        usernameVariable: 'AWS_ACCESS_KEY_ID',
        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
      )
    ]) {
            sh '''
        terraform apply -auto-approve \
          -var="region=us-east-2"
      '''
    }
    }
}
