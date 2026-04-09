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
                sh 'terraform workspace show'
                sh "terraform workspace switch ${params.WORK_SPACE}" 
                if ( sh '$?' ){
                    echo 'create workspace'
                }
                else{
                    echo 'switching workspace'
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