pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        GITHUB_TOKEN          = credentials('github-token')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                // Use the GitHub token in the Git URL for authentication 
                git branch: 'main', url: '//github.com/ajaysingh3200/terraform-jenkins-pipeline.git', credentialsId: 'github-token'
            }
        }
        stage('Terraform init') {
            steps {
                
                sh 'terraform init'
            }
        }
        stage('Terraform fmt') {
            steps {
                
                sh 'terraform fmt'
            }
        }
        stage('Terraform validate') {
            steps {
                
                sh 'terraform validate'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -out tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }

    }
}
