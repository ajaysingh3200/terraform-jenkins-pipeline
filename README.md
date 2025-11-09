A complete Infrastructure as Code (IaC) solution with automated CI/CD pipeline using Terraform and Jenkins for multi-environment AWS infrastructure deployment.

## 🚀 Features

- **Multi-Environment Deployment**: Dev, Staging, and Production environments
- **Automated CI/CD**: Jenkins pipeline with GitHub webhook triggers
- **Infrastructure as Code**: Terraform for AWS resource management
- **Security Best Practices**: IAM roles, secure credential management
- **Network Isolation**: Separate VPCs for each environment

## 📋 Prerequisites

- AWS Account with appropriate permissions
- Jenkins server with required plugins
- GitHub repository access
- Terraform installed on Jenkins agent

## 🏗️ Infrastructure Components

### AWS Resources Created:
- **VPC** with Internet Gateway
- **3 Public Subnets** across different Availability Zones
- **EC2 Instances** with environment-specific configurations
- **Route Tables** and associations
- **Security Groups**

### Environment Specifications:
| Environment | Instance Type | Monitoring | CIDR Block     |
|-------------|---------------|------------|----------------|
| Development | t3.micro      | Disabled   | 10.1.0.0/16    |
| Staging     | t3.medium     | Enabled    | 10.2.0.0/16    |
| Production  | t3.large      | Enabled    | 10.3.0.0/16    |

## 📁 Project Structure


## ⚙️ Setup Instructions

### 1. Jenkins Configuration

#### Credentials Setup:
1. **AWS Credentials** (Username with password):
   - ID: `aws-credentials`
   - Username: AWS Access Key ID
   - Password: AWS Secret Access Key

2. **GitHub Token** (Secret text):
   - ID: `github-token`
   - Secret: GitHub Personal Access Token

### 2. GitHub Webhook Setup

1. Go to repository **Settings** → **Webhooks**
2. Add webhook:
   - Payload URL: `http://your-jenkins-url:8080/github-webhook/`
   - Content type: `application/json`
   - Events: `Push events`

## 🛠️ Usage

### Manual Deployment via Jenkins:

1. **Go to Jenkins pipeline**
2. **Click "Build with Parameters"**
3. **Select parameters:**
   - `ENVIRONMENT`: dev, staging, or production
   - `action`: apply or destroy
   - `autoApprove`: true for automatic, false for manual approval

### Pipeline Stages:

1. **Checkout**: Pulls latest code from repository
2. **Workspace Selection**: Sets up Terraform workspace
3. **Terraform Init**: Initializes Terraform backend
4. **Terraform Validate**: Validates Terraform configuration
5. **Terraform Plan**: Generates execution plan
6. **Manual Approval**: Required for production
7. **Apply/Destroy**: Executes Terraform changes
8. **Outputs**: Displays created resources

## 📊 Outputs

After successful deployment:
- VPC ID
- Internet Gateway ID
- Subnet IDs
- EC2 Instance ID and Public IP
- Subnet CIDR blocks
EOF