# Monolith_App_Hosting_Deployment

**PreReq** -
1. AWS IAM user with Access Key and Secret Key.
2. Repository in GitHub.
3. Monolith Python App

**Overall Blueprint/Highlevel Steps** - 
1. Create AWS Infra for hosting the app via Iac in Dev env with HA.
2. Test connectivity and security.
3. Deploy infra to Prod.
4. Lambda Function to shutdown EC2 at 6 PM and Start at 10 AM IST in non-prod env.

**Tools/Apps Used** -
1. AWS - VPC, EC2, ALB, S3, IAM, Route 53, Secret Manager, Lambda
2. IaC - Terraform
3. CICD - GitLabs/ Github Actions
4. Draw.io
5. OS - Amazon Linux
6. Monolith Python App


Deployment is in prog
