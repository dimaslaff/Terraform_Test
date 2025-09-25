pipeline {
    agent any
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Select the target environment')
        booleanParam(name: 'DESTROY_RESOURCES', defaultValue: false, description: 'Check to destroy resources instead of applying.')
    }

    environment {
        PLAN_FILE = "${params.ENVIRONMENT}.plan"
        RECIPIENTS = "dimas@superpari.co.id"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: '[https://github.com/your-org/your-repo.git](https://github.com/your-org/your-repo.git)'
            }
        }
        
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init -backend-config="key=environments/${params.ENVIRONMENT}/terraform.tfstate"'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def planCommand = "terraform plan -var-file=${params.ENVIRONMENT}.tfvars -out=${PLAN_FILE}"
                    if (params.DESTROY_RESOURCES) {
                        planCommand += " -destroy"
                    }
                    sh planCommand
                }
            }
        }

        stage('Manual Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input message: "Approve deployment to ${params.ENVIRONMENT} environment?",
                          ok: 'Proceed with Apply'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh "terraform apply -auto-approve ${PLAN_FILE}"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded. Sending email notification."
            mail(to: env.RECIPIENTS, subject: "SUCCESS: Terraform Build for ${params.ENVIRONMENT}", body: "The Terraform changes were successfully applied.")
        }
        failure {
            echo "Pipeline failed. Sending email notification."
            mail(to: env.RECIPIENTS, subject: "FAILURE: Terraform Build for ${params.ENVIRONMENT}", body: "The Terraform pipeline failed. Check the build logs for details.")
        }
    }
}
