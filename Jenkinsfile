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
                script{
                    def status = sh(
                        script: "terraform workspace select ${params.WORK_SPACE}",
                        returnStatus: true
                    )
                    if (status == 0){
                        echo 'existss'
                    }
                    else{
                        echo 'switching workspace'
                    }
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