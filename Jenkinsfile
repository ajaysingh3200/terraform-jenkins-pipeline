pipeline {
    agent { label "vinod" }

    triggers {
        githubPush()
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'production'], description: 'Select deployment environment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_VAR_environment = "${params.ENVIRONMENT}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ajaysingh3200/terraform-jenkins-pipeline.git', credentialsId: 'github-token'
            }
        }
        
        stage('Select Workspace') {
            steps {
                script {
                    sh "terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}"
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-credentials',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Validate') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-credentials',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh 'terraform validate'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-credentials',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh "terraform plan -var-file=environments/${params.ENVIRONMENT}.tfvars -out tfplan"
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }
        
        stage('Manual Approval') {
            when {
                expression { params.ENVIRONMENT == 'production' && params.action == 'apply' && !params.autoApprove }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "PRODUCTION DEPLOYMENT - Please review the plan",
                    parameters: [text(name: 'Plan', description: 'Production deployment - review carefully', defaultValue: plan)]
                }
            }
        }
        
        stage('Apply / Destroy') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'aws-credentials',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )]) {
                        if (params.action == 'apply') {
                            sh "terraform apply -var-file=environments/${params.ENVIRONMENT}.tfvars -auto-approve"
                            
                            // Display outputs - FIXED: Using terraform output commands instead of readJSON
                            echo "=== ${params.ENVIRONMENT.toUpperCase()} Environment Deployment Complete ==="
                            sh """
                                echo "VPC ID: \$(terraform output -raw vpc_id)"
                                echo "Internet Gateway ID: \$(terraform output -raw internet_gateway_id)"
                                echo "Subnet 1: \$(terraform output -raw public_subnet_1_id)"
                                echo "Subnet 2: \$(terraform output -raw public_subnet_2_id)"
                                echo "Subnet 3: \$(terraform output -raw public_subnet_3_id)"
                                echo "EC2 Instance: \$(terraform output -raw instance_id)"
                                echo "Public IP: \$(terraform output -raw public_ip)"
                                echo "Subnet CIDRs: \$(terraform output public_subnet_cidrs)"
                            """
                            
                        } else if (params.action == 'destroy') {
                            sh "terraform destroy -var-file=environments/${params.ENVIRONMENT}.tfvars -auto-approve"
                            echo "${params.ENVIRONMENT.toUpperCase()} environment destroyed successfully!"
                        } else {
                            error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo "${params.ENVIRONMENT.toUpperCase()} deployment completed successfully!"
        }
        failure {
            echo "${params.ENVIRONMENT.toUpperCase()} deployment failed!"
        }
    }
}