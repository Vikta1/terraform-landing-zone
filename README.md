Terraform AWS Landing Zone (Multi-Account Architecture)

A complete, production-grade AWS multi-account Landing Zone built entirely with Terraform, implementing enterprise governance, security guardrails, centralized logging, delegated admin, and IAM Identity Center (AWS SSO) access management.

This project replicates the cloud foundations used by large enterprises, banks, and government environments.

 Architecture Overview

This Landing Zone includes:

AWS Organizations (Root + OUs)

Multi-account structure

Security Account

Logging Account

Shared Services Account

Dev Account

Prod Account

Sandbox

Service Control Policies (SCPs) for governance

GuardDuty & Security Hub delegated admin

Centralized CloudTrail (Org Trail)

Cross-Account IAM Roles (Audit & Logging)

IAM Identity Center (AWS SSO)

Permission sets

Group assignments

Account access provisioning

Terraform-based automation

Enterprise tagging strategy

This is a real, scalable Landing Zone architecture suitable for enterprise cloud security roles.

 Project Features
 1. AWS Organizations

Creates the organization with feature_set = ALL

Automatically provisions Organizational Units:

Security

Infrastructure

Workloads

Sandbox

 2. Multi-Account Creation

Terraform automatically provisions AWS accounts:

<project>-security-dev

<project>-logging-dev

<project>-shared-services-dev

<project>-dev-dev

<project>-prod-dev

<project>-sandbox-dev

Each account is assigned:

A parent OU

A login role

Billing access restrictions

 3. Service Control Policies (SCPs)

Enterprise-grade guardrails:

Deny disabling critical security services

CloudTrail

GuardDuty

Security Hub

AWS Config

Enforce approved AWS regions only

(e.g., us-east-1, us-west-2)

Deny IAM wildcard (*) policies

Promotes least-privilege IAM.

 4. Security Services (Delegated Admin)

Configured at the organization level:

GuardDuty

Security Hub

Organization-wide CloudTrail

Central S3 log bucket

IAM Access Analyzer (optional)

A dedicated Security Account becomes the delegated administrator.

 5. IAM Identity Center (AWS SSO)

Centralized identity and access management:

Permission sets:

Administrator

Developer

Read-Only

Group assignments mapped to:

Security Account

Logging Account

Dev

Prod

Sandbox

Shared Services

This is the modern industry standard for AWS access.

 6. Cross-Account IAM Roles

Organization Audit Role (assumed by Security Account)

Logging Role (assumed by Logging Account)

Allows secure cross-account visibility without exposing credentials.

 7. Clean Terraform Project Structure
.
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── org.tf
├── accounts.tf
├── scp.tf
├── security-services.tf
├── identity-center.tf
├── roles.tf
└── README.md


No .terraform folder — clean Git history and properly ignored provider binaries.

 Skills Demonstrated

This project demonstrates hands-on experience with:

AWS Organizations & multi-account design

Enterprise cloud governance & SCP guardrails

IAM Identity Center (SSO)

Centralized logging strategy

Delegated security administration

Terraform IaC best practices

Cross-account IAM role trust relationships

Cloud security architecture at scale

Perfect for roles such as:

Cloud Security Engineer

Cloud Architect

DevSecOps Engineer

Security Consultant

AWS Security Specialist

 How to Use
1. Clone the repo
git clone https://github.com/Vikta1/terraform-landing-zone.git
cd terraform-landing-zone

2. Initialize Terraform
terraform init

3. Validate configuration
terraform validate

4. Deploy to AWS (Warning: real accounts will be created)
terraform apply


Ensure AWS credentials are configured with the Management Account (Root).

 Important Notes

AWS account creation is real and irreversible

Ensure billing alarms exist before provisioning

Deployment requires management account permissions

SCPs may block actions if not planned carefully

Identity Center must already exist (Terraform cannot create it)

 Architecture Diagram (Add Your Own Image Here)

You can add an image later, e.g.:

![AWS Landing Zone Architecture](images/landing-zone-diagram.png)


If you want, I can generate a diagram for you.

 Author

Victor Oru
Senior Cybersecurity & Cloud Security Engineer
Terraform | AWS | DevSecOps | PAM | GRC
