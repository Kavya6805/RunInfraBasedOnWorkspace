pipeline {
    agent any

    parameters{
        choice(name: 'WORK_SPACE', choices: ['Dev', 'Prod', 'Test'], description: 'Enter workspace')

    }

    stages{
        stage('Verify Terraform') {
            steps {
                sh 'terraform --version'
            }
        }
        stage('Terraform init') {
            steps {
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', 
                                   credentialsId: 'aws-global-creds']]) {
                    sh 'terraform init' 
                }
            }
        }
        stage('Create/Switch workspace'){
            steps{
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', 
                                   credentialsId: 'aws-global-creds']]) {
                    sh 'terraform workspace show'
                    script{
                        def status = sh(
                            script: "terraform workspace select ${params.WORK_SPACE}",
                            returnStatus: true
                        )
                        if (status != 0){
                            sh "terraform workspace new ${params.WORK_SPACE}"
                            sh "terraform workspace select ${params.WORK_SPACE}"
                        }
                    }
                    sh 'terraform workspace show'
                }
            }
        }
        stage('Terraform plan') {
           steps {
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', 
                                   credentialsId: 'aws-global-creds']]) {
                    sh "terraform plan -var='workspace=${params.WORK_SPACE}'" 
                }
                input message: 'Do you want to proceed to the next stage?'
            }
        }
        stage('Terraform apply') {
            steps {
                withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', 
                                   credentialsId: 'aws-global-creds']]) {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
    post{
        always{
            deleteDir()
        }
    }
}