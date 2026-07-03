# AWS Terraform Infrastructure Lab

## Overview

This folder contains the Terraform infrastructure used to support the AWS monitoring and infrastructure dashboard project.

The goal of this Terraform lab is to model real-world Infrastructure-as-Code practices, including reusable modules, separate root stacks, remote state, environment-specific configuration, standardized naming, tagging, security group management, and operational monitoring as code.

This is not intended to be a one-off Terraform script. It is structured as a small enterprise-style AWS IaC project.

---

## What This Project Builds

The Terraform code currently manages AWS infrastructure across compute, network, storage, monitoring, and remote state.

Current capabilities include:

- Linux and Windows EC2 provisioning
- Platform-specific security groups for Linux and Windows management access
- EC2 fleet-level CloudWatch high CPU monitoring
- SNS and Lambda action integration for high CPU remediation
- S3 storage resource management
- Remote Terraform state stored in S3
- Separate state files for compute, network, and storage stacks
- Reusable Terraform modules
- Environment-specific variable examples
- GitHub-safe example files for backend and tfvars configuration

---

## Architecture Summary

```text
AWS Terraform Lab
│
├── Bootstrap / Remote State
│   └── Dedicated S3 backend bucket
│       ├── lab/compute/terraform.tfstate
│       ├── lab/network/terraform.tfstate
│       └── lab/storage/terraform.tfstate
│
├── Network Stack
│   ├── Linux-Management-TF security group
│   └── Windows-Management-TF security group
│
├── Compute Stack
│   ├── LAB-APP-LNX-002
│   ├── LAB-APP-WIN-003
│   └── TF-EC2-Fleet-HighCPU CloudWatch alarm
│
└── Storage Stack
    └── Terraform-managed S3 test bucket
Repository Structure
terraform/aws-lab
│
├── bootstrap
│   └── remote-state
│       ├── providers.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars.example
│       └── outputs.tf
│
├── envs
│   └── lab
│       ├── compute
│       │   ├── backend.tf.example
│       │   ├── providers.tf
│       │   ├── linux.tf
│       │   ├── windows.tf
│       │   ├── monitoring.tf
│       │   ├── variables.tf
│       │   ├── terraform.tfvars.example
│       │   └── outputs.tf
│       │
│       ├── network
│       │   ├── backend.tf.example
│       │   ├── providers.tf
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── terraform.tfvars.example
│       │   └── outputs.tf
│       │
│       └── storage
│           ├── backend.tf.example
│           ├── providers.tf
│           ├── main.tf
│           ├── variables.tf
│           ├── terraform.tfvars.example
│           └── outputs.tf
│
└── modules
    ├── ec2-instance
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── cloudwatch-metric-alarm
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── security-group
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
Terraform Design
Reusable Modules

Reusable modules are stored under:

modules/

These modules contain generic infrastructure patterns that can be reused by different stacks.

Module	Purpose
ec2-instance	Creates standardized EC2 instances using AMI, instance type, subnet, security groups, IAM instance profile, naming, and tags
security-group	Creates security groups with separate ingress and egress rule resources
cloudwatch-metric-alarm	Creates CloudWatch metric alarms using metric query expressions

The modules do not hardcode lab-specific values. Environment-specific details are passed in from the root stacks.

Root Stacks

Root stacks are stored under:

envs/lab/

Each root stack has a separate purpose and separate Terraform state.

Stack	Purpose	Remote State Key
compute	EC2 instances and CloudWatch monitoring	lab/compute/terraform.tfstate
network	Security groups and management access rules	lab/network/terraform.tfstate
storage	S3 test/application bucket	lab/storage/terraform.tfstate

This separation reduces blast radius. Compute, network, and storage can be planned and applied independently.

Remote State

Terraform state is stored remotely in a dedicated S3 backend bucket.

The state bucket is created by the bootstrap stack:

bootstrap/remote-state

The backend bucket is configured with:

S3 versioning
Server-side encryption
Public access block
Terraform ownership tags

Current remote state layout:

lab/compute/terraform.tfstate
lab/network/terraform.tfstate
lab/storage/terraform.tfstate

The actual backend.tf files are intentionally not committed to GitHub. Instead, this repo includes:

backend.tf.example

This allows the project structure to be shared publicly without exposing real backend bucket names or account-specific values.

Compute Stack

Path:

envs/lab/compute

The compute stack manages:

Linux EC2 instance
Windows EC2 instance
EC2 fleet high CPU CloudWatch alarm

Current compute resources include:

Linux EC2:
LAB-APP-LNX-002

Windows EC2:
LAB-APP-WIN-003

CloudWatch Alarm:
TF-EC2-Fleet-HighCPU

The compute stack calls the reusable EC2 module separately for Linux and Windows workloads.

Linux and Windows have separate input values for:

AMI ID
Instance type
Naming prefix
Starting number
Server count
Security group IDs
Tags

This allows the same EC2 module to support multiple platform types without duplicating EC2 resource code.

Network Stack

Path:

envs/lab/network

The network stack manages Terraform-created security groups.

Current security groups include:

Linux-Management-TF
Windows-Management-TF

The security groups are created through the reusable security-group module.

The Linux security group allows SSH from a trusted admin CIDR.

The Windows security group allows RDP from a trusted admin CIDR.

For lab use, the admin CIDR is configured as a /32 public IP. In a production model, direct SSH/RDP access would typically be replaced or restricted through one of the following:

AWS Systems Manager Session Manager
Bastion host
AWS Client VPN
Corporate VPN egress CIDR
Zero Trust access platform
Storage Stack

Path:

envs/lab/storage

The storage stack manages a Terraform-created S3 bucket used as a test/application storage resource.

This bucket is separate from the Terraform remote state bucket.

That distinction is intentional:

Application/data bucket  -> managed infrastructure resource
Terraform state bucket   -> backend/control-plane resource

The Terraform state bucket should not be mixed with application buckets.

CloudWatch Monitoring

The compute stack creates a Terraform-managed CloudWatch alarm:

TF-EC2-Fleet-HighCPU

The alarm uses a CloudWatch Metrics Insights query:

SELECT MAX(CPUUtilization)
FROM SCHEMA("AWS/EC2", InstanceId)
GROUP BY InstanceId
ORDER BY MAX() DESC

This allows the alarm to evaluate CPU utilization across the EC2 fleet instead of being tied to a single static instance.

The alarm action path includes:

SNS notification
Lambda remediation function

This models an operational control pattern where Terraform manages not only infrastructure provisioning, but also monitoring and remediation hooks.

GitHub-Safe Files

This repo intentionally commits example files instead of real runtime values.

Committed examples:

terraform.tfvars.example
backend.tf.example

Ignored local runtime files:

terraform.tfvars
backend.tf
terraform.tfstate
terraform.tfstate.backup
.terraform/

This allows the repo to show the Terraform structure and logic without exposing real AWS account-specific configuration.

Important File Types
providers.tf

Defines the AWS provider, region, and profile used by the stack.

backend.tf.example

Shows how the S3 backend should be configured.

The real backend.tf file is used locally but ignored by Git.

variables.tf

Defines the input variables expected by the stack or module.

terraform.tfvars.example

Shows safe example values.

The real terraform.tfvars file is used locally but ignored by Git.

outputs.tf

Exposes useful created resource values such as instance IDs, private IPs, public IPs, security group IDs, and CloudWatch alarm ARNs.

.terraform.lock.hcl

Locks Terraform provider versions for consistent behavior.

Deployment Workflow
1. Bootstrap Remote State

The remote state bucket must exist before the other stacks can use it.

cd terraform/aws-lab/bootstrap/remote-state
terraform init
terraform validate
terraform plan
terraform apply
2. Deploy Network Stack

The network stack creates the security groups.

cd terraform/aws-lab/envs/lab/network
terraform init
terraform validate
terraform plan
terraform apply
terraform output
3. Deploy Compute Stack

The compute stack creates EC2 instances and monitoring.

cd terraform/aws-lab/envs/lab/compute
terraform init
terraform validate
terraform plan
terraform apply
terraform output
4. Deploy Storage Stack

The storage stack manages the S3 test/application bucket.

cd terraform/aws-lab/envs/lab/storage
terraform init
terraform validate
terraform plan
terraform apply
terraform output
Validation Commands

Check managed resources in a stack:

terraform state list

Confirm the stack matches AWS:

terraform plan

Verify remote state objects:

aws s3 ls s3://your-terraform-state-bucket-name/lab/ --recursive

Expected layout:

lab/compute/terraform.tfstate
lab/network/terraform.tfstate
lab/storage/terraform.tfstate
What This Project Demonstrates

This project demonstrates practical Terraform and AWS infrastructure skills:

Infrastructure as Code design
Modular Terraform structure
Reusable modules
Separate root stacks
Remote S3 backend state
State separation by environment and stack
AWS EC2 provisioning
Linux and Windows workload support
Security group management
CloudWatch Metrics Insights alarm creation
SNS and Lambda action integration
Standardized tagging and naming
Terraform plan/apply workflow
Safe incremental infrastructure changes
GitHub-safe handling of sensitive runtime values
Production Considerations

This lab models enterprise Terraform concepts, but a production implementation would typically add:

CI/CD-based Terraform plan and approval workflow
Separate AWS accounts for dev/test/prod
IAM least privilege for Terraform execution
Centralized module registry or versioned modules
SSM Session Manager instead of direct SSH/RDP
Additional monitoring and alerting standards
Secrets management through AWS Secrets Manager, SSM Parameter Store, or CI/CD secrets
Formal drift detection
Pull request policy checks
Automated security scanning
Future Improvements

Planned enhancements:

Add GitHub Actions for terraform fmt, terraform validate, and terraform plan
Add architecture diagrams and screenshots
Add IAM role and policy modules
Add SSM Session Manager access pattern
Add additional CloudWatch alarms
Add import and drift detection examples
Add dashboard screenshots showing the Terraform-managed resources