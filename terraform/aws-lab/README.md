# AWS Terraform Infrastructure Lab

## Overview

This repository contains the Terraform infrastructure used to support the AWS monitoring and infrastructure dashboard project.

The goal of this lab is to model practical, enterprise-style Infrastructure-as-Code practices, including:

- Reusable Terraform modules
- Separate root stacks with isolated state
- Remote S3 backend state and state locking
- Environment-specific configuration
- Standardized naming and tagging
- Infrastructure monitoring and remediation hooks
- Git-based change control
- Pull-request validation
- OIDC-based AWS authentication
- Separate plan and apply permissions
- Reviewed-plan approval before deployment

This is not intended to be a one-off Terraform script. It is structured as a small enterprise-style AWS IaC project with both infrastructure code and a controlled CI/CD deployment workflow.

---

## What This Project Builds

The Terraform code currently manages AWS infrastructure across compute, network, storage, monitoring, FinOps, WorkSpaces, and remote state.

Current capabilities include:

- Linux and Windows EC2 provisioning
- Platform-specific security groups for Linux and Windows management access
- EC2 fleet-level CloudWatch high CPU monitoring
- SNS and Lambda action integration for high CPU remediation
- S3 storage resource management
- AWS Budget management through a dedicated FinOps stack
- Amazon WorkSpaces Personal deployment through a dedicated WorkSpaces stack
- Reusable WorkSpaces module for AWS-provided Windows bundles and AutoStop configuration
- Import of an existing manually created AWS Budget into Terraform state
- Remote Terraform state stored in S3
- Separate state files for compute, network, storage, FinOps, and WorkSpaces stacks
- Reusable Terraform modules
- Environment-specific variable examples
- GitHub-safe example files for backend and tfvars configuration
- GitHub Actions validation and deployment workflows
- OIDC authentication with short-lived AWS credentials
- Separate read-only plan and controlled apply IAM roles
- Manual approval of an exact saved Terraform plan before apply

---

## Architecture Summary

```text
AWS Terraform Lab
│
├── Bootstrap / Remote State
│   └── Dedicated S3 backend bucket
│       ├── lab/compute/terraform.tfstate
│       ├── lab/network/terraform.tfstate
│       ├── lab/storage/terraform.tfstate
│       ├── lab/finops/terraform.tfstate
│       └── lab/workspaces/terraform.tfstate
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
├── Storage Stack
│   └── Terraform-managed S3 test bucket
│
├── FinOps Stack
│   └── Terraform-managed AWS Budget
│
├── WorkSpaces Stack
│   └── Terraform-managed Amazon WorkSpaces Personal desktop
│
└── GitHub Actions CI/CD
    ├── Pull-request formatting and validation
    ├── Read-only Terraform plan through AWS OIDC
    ├── Saved plan artifact for review
    ├── Protected approval environment
    └── Apply of the exact approved plan
```

---

## Repository Structure

```text
enterprise-monitoring-dashboard
│
├── .github
│   └── workflows
│       ├── terraform-ci.yml
│       ├── terraform-finops-apply.yml
│       └── terraform-workspaces-apply.yml
│
└── terraform
    └── aws-lab
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
        │       ├── storage
        │       │   ├── backend.tf.example
        │       │   ├── providers.tf
        │       │   ├── main.tf
        │       │   ├── variables.tf
        │       │   ├── terraform.tfvars.example
        │       │   └── outputs.tf
        │       │
        │       ├── finops
        │       │   ├── backend.tf.example
        │       │   ├── imports.tf
        │       │   ├── main.tf
        │       │   ├── outputs.tf
        │       │   ├── providers.tf
        │       │   ├── variables.tf
        │       │   └── terraform.tfvars.example
        │       │
        │       └── workspaces
        │           ├── main.tf
        │           ├── outputs.tf
        │           ├── providers.tf
        │           └── variables.tf
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
            ├── security-group
            │   ├── main.tf
            │   ├── variables.tf
            │   └── outputs.tf
            │
            └── workspaces-personal
                ├── main.tf
                ├── variables.tf
                └── outputs.tf
```

---

## Terraform Design

### Reusable Modules

Reusable modules are stored under:

```text
terraform/aws-lab/modules/
```

| Module | Purpose |
|---|---|
| `ec2-instance` | Creates standardized EC2 instances using AMI, instance type, subnet, security groups, IAM instance profile, naming, and tags |
| `security-group` | Creates security groups with separate ingress and egress rule resources |
| `cloudwatch-metric-alarm` | Creates CloudWatch metric alarms using metric-query expressions |
| `workspaces-personal` | Creates an Amazon WorkSpaces Personal desktop using an existing registered directory, AWS bundle, user, AutoStop settings, sizing, and tags |

The modules do not hardcode lab-specific values. Environment-specific details are passed in from the root stacks.

### Root Stacks

Root stacks are stored under:

```text
terraform/aws-lab/envs/lab/
```

Each root stack has a separate purpose and separate Terraform state.

| Stack | Purpose | Remote state key |
|---|---|---|
| `compute` | EC2 instances and CloudWatch monitoring | `lab/compute/terraform.tfstate` |
| `network` | Security groups and management access rules | `lab/network/terraform.tfstate` |
| `storage` | S3 test/application bucket | `lab/storage/terraform.tfstate` |
| `finops` | AWS Budget and related FinOps controls | `lab/finops/terraform.tfstate` |
| `workspaces` | Amazon WorkSpaces Personal desktop deployment | `lab/workspaces/terraform.tfstate` |

This separation reduces blast radius because each stack can be planned and applied independently.

---

## Remote State

Terraform state is stored remotely in a dedicated S3 backend bucket created by:

```text
terraform/aws-lab/bootstrap/remote-state
```

The backend bucket is configured with:

- S3 versioning
- Server-side encryption
- Public access blocking
- Terraform ownership tags
- S3-based Terraform state locking

Current remote-state layout:

```text
lab/compute/terraform.tfstate
lab/network/terraform.tfstate
lab/storage/terraform.tfstate
lab/finops/terraform.tfstate
lab/workspaces/terraform.tfstate
```

Real `backend.tf` files are intentionally excluded from source control. The repository includes `backend.tf.example` files so the project structure can be shared without publishing account-specific backend settings.

---

## Compute Stack

Path:

```text
terraform/aws-lab/envs/lab/compute
```

The compute stack manages:

- Linux EC2 instances
- Windows EC2 instances
- EC2 fleet high-CPU CloudWatch monitoring

Current resources include:

```text
Linux EC2:        LAB-APP-LNX-002
Windows EC2:      LAB-APP-WIN-003
CloudWatch alarm: TF-EC2-Fleet-HighCPU
```

The same reusable EC2 module supports both Linux and Windows workloads through platform-specific input values such as AMI ID, instance type, naming prefix, server count, security groups, and tags.

---

## Network Stack

Path:

```text
terraform/aws-lab/envs/lab/network
```

The network stack manages Terraform-created security groups through the reusable `security-group` module.

Current security groups include:

```text
Linux-Management-TF
Windows-Management-TF
```

The Linux security group allows SSH from a trusted administrative CIDR, while the Windows security group allows RDP from a trusted administrative CIDR.

For a production implementation, direct SSH or RDP access would normally be replaced or further restricted through services such as:

- AWS Systems Manager Session Manager
- Bastion hosts
- AWS Client VPN
- Corporate VPN egress CIDRs
- Zero Trust access platforms

---

## Storage Stack

Path:

```text
terraform/aws-lab/envs/lab/storage
```

The storage stack manages a Terraform-created S3 bucket used as a test or application-storage resource.

This bucket is separate from the Terraform state bucket:

```text
Application/data bucket  -> managed infrastructure resource
Terraform state bucket   -> backend/control-plane resource
```

Keeping application storage separate from Terraform state is intentional.

---

## FinOps Stack

Path:

```text
terraform/aws-lab/envs/lab/finops
```

The FinOps stack manages an AWS monthly cost budget and its email notification configuration.

The initial budget existed manually in AWS and was adopted through a Terraform declarative import block. The reviewed deployment plan confirmed:

```text
1 to import, 0 to add, 0 to change, 0 to destroy
```

The apply workflow then associated the existing AWS Budget with:

```text
aws_budgets_budget.zero_spend
```

in the remote FinOps state without recreating or changing the budget.

The provider configuration supports both:

- A local AWS CLI profile for development and testing
- Temporary OIDC credentials in GitHub Actions

---


## WorkSpaces Stack

Path:

```text
terraform/aws-lab/envs/lab/workspaces
```

The WorkSpaces stack manages an Amazon WorkSpaces Personal desktop through the reusable `workspaces-personal` Terraform module. The stack uses an existing Simple AD-backed WorkSpaces directory, an existing registered WorkSpaces directory, an AWS-provided Windows bundle, and an existing directory user.

Current deployment characteristics:

```text
Directory:    Existing Simple AD-backed WorkSpaces directory
Bundle:       Standard with Windows (Server 2025 based)
Compute:      STANDARD
Root volume:  80 GiB
User volume:  50 GiB
Running mode: AUTO_STOP
AutoStop:     60 minutes
```

Terraform manages the WorkSpace resource, tags, compute sizing, root and user volume sizing, AutoStop configuration, and outputs such as WorkSpace ID, private IP address, and state. The WorkSpaces resources are deployed in `us-east-1`, while the Terraform state bucket remains in `us-east-2`.

The WorkSpaces deployment also demonstrated operational state handling after an AWS-side provisioning timeout. The WorkSpace was validated in AWS, Terraform taint was removed after confirming the resource was healthy, and state/output reconciliation was completed through the GitHub Actions deployment workflow.

---

## CloudWatch Monitoring

The compute stack creates the Terraform-managed alarm:

```text
TF-EC2-Fleet-HighCPU
```

The alarm uses a CloudWatch Metrics Insights query:

```sql
SELECT MAX(CPUUtilization)
FROM SCHEMA("AWS/EC2", InstanceId)
GROUP BY InstanceId
ORDER BY MAX() DESC
```

This allows the alarm to evaluate CPU utilization across the EC2 fleet rather than being tied to one static instance.

The alarm action path includes:

- SNS notification
- Lambda remediation (Python code will auto-detect windows/linux and will kill specific high usage processes tailored to sepcifc workflow or environment)

This models an operational-control pattern where Terraform manages infrastructure provisioning, monitoring, and remediation hooks.

---

## CI/CD Pipeline

The repository includes a GitHub Actions pipeline that separates continuous integration from controlled deployment.

### Pull-Request CI

Workflow:

```text
.github/workflows/terraform-ci.yml
```

The CI workflow runs when Terraform code or Terraform workflow files change.

It performs:

- Repository checkout
- Terraform installation
- `terraform fmt -check -recursive`
- Matrix-based validation of bootstrap, network, compute, storage, FinOps, and WorkSpaces stacks
- `terraform init -backend=false`
- `terraform validate`
- A real FinOps plan against the remote S3 backend
- AWS authentication through GitHub OIDC
- Use of a read-oriented FinOps plan role

The FinOps PR plan allows reviewers to inspect intended AWS changes before code is merged.

### Protected Plan and Apply Workflows

Workflows:

```text
.github/workflows/terraform-finops-apply.yml
.github/workflows/terraform-workspaces-apply.yml
```

The deployment workflows are started manually from `main` and use two separate jobs.

#### Plan job

The plan job:

1. Assumes the appropriate read-only plan role through OIDC
2. Initializes the remote S3 backend
3. Generates a saved binary Terraform plan
4. Creates a human-readable plan file
5. Uploads both files as a GitHub Actions artifact

Artifacts:

```text
finops.tfplan
finops-plan.txt
workspaces.tfplan
workspaces-plan.txt
```

#### Apply job

The apply job:

1. Depends on successful completion of the plan job
2. Waits at the protected GitHub environment, such as `finops-apply` or `workspaces-apply`
3. Requires a reviewer to inspect and approve the plan
4. Assumes the separate apply role through OIDC
5. Downloads the exact saved binary plan
6. Applies that exact reviewed plan

This avoids generating a different plan after approval.

### Pipeline Flow

```text
Local Terraform change
        ↓
Feature branch
        ↓
Git push
        ↓
Pull request
        ↓
Format and validation checks
        ↓
Read-only Terraform plan
        ↓
Peer review and merge to main
        ↓
Manual deployment workflow
        ↓
Saved plan generated and published
        ↓
Reviewer inspects the readable plan artifact
        ↓
Protected environment approval
        ↓
Exact saved `.tfplan` artifact is applied
        ↓
Remote Terraform state updated
```

---

## AWS Authentication and Authorization

The pipeline does not store permanent AWS access keys.

GitHub Actions requests a short-lived OIDC token from GitHub and presents it to AWS Security Token Service. AWS validates the token against the IAM role trust policy and issues temporary credentials for the workflow run.

```text
GitHub Actions
    ↓
GitHub OIDC token
    ↓
AWS STS
    ↓
Temporary role credentials
```

Two IAM roles enforce separation of duties:

```text
GitHubActions-Terraform-FinOps-Plan
GitHubActions-Terraform-FinOps-Apply
GitHubActions-Terraform-Lab-Plan
GitHubActions-Terraform-Lab-Apply
```

### Plan role

The plan role is intended for lower-risk read and planning activity. It can read:

- The relevant Terraform state
- AWS Budget resources for FinOps planning
- WorkSpaces directory, bundle, tag, and WorkSpace metadata for WorkSpaces planning
- AWS account identity

### Apply role

The apply role can:

- Read and update the relevant Terraform state
- Create and remove the S3 state-lock object
- Manage AWS Budgets within the approved FinOps scope
- Manage WorkSpaces resources within the approved WorkSpaces scope
- Manage resource tags

The apply roles can be assumed only by approved repository workflows using protected environments such as `finops-apply` and `workspaces-apply`.

The model separates:

```text
Trust policy       -> who may assume the role
Permissions policy -> what the role may do
```

---

## GitHub Environment Protection

The `finops-apply` and `workspaces-apply` GitHub environments provide manual deployment gates.

Controls include:

- Required reviewer approval
- Deployment restricted to `main`
- Apply job blocked until approval
- Environment-specific OIDC identity used by the AWS trust policy

The reviewer can inspect the completed plan-job log and download the readable plan artifact, such as `finops-plan.txt` or `workspaces-plan.txt`, before approving deployment.

---

## GitHub-Safe Files and Values

The repository commits examples instead of local runtime values.

Committed examples:

```text
terraform.tfvars.example
backend.tf.example
```

Ignored local runtime files:

```text
terraform.tfvars
backend.tf
terraform.tfstate
terraform.tfstate.backup
.terraform/
*.tfplan
```

GitHub repository variables provide non-sensitive pipeline configuration such as:

```text
AWS_REGION
TERRAFORM_STATE_BUCKET
FINOPS_BUDGET_NAME
FINOPS_BUDGET_LIMIT
AWS_FINOPS_PLAN_ROLE_ARN
AWS_FINOPS_APPLY_ROLE_ARN
AWS_WORKSPACES_PLAN_ROLE_ARN
AWS_WORKSPACES_APPLY_ROLE_ARN
```

Sensitive values such as the budget notification email are stored as GitHub Actions secrets rather than committed to the repository.

---

## Important File Types

### `providers.tf`

Defines the AWS provider and supports either a local AWS profile or temporary pipeline credentials.

### `backend.tf.example`

Documents the S3 backend configuration. Real `backend.tf` files are ignored.

### `variables.tf`

Defines stack and module inputs.

### `terraform.tfvars.example`

Provides safe example values. Real `terraform.tfvars` files are ignored.

### `outputs.tf`

Exposes useful resource values such as instance IDs, IP addresses, security group IDs, alarm ARNs, budget identifiers, and WorkSpace IDs/states.

### `.terraform.lock.hcl`

Locks provider versions for consistent behavior across local and CI runs.

### `imports.tf`

Defines declarative imports for existing AWS resources that are being adopted into Terraform state.

---

## Local Validation Commands

Format Terraform files:

```powershell
terraform fmt -recursive
```

Validate a stack:

```powershell
terraform init
terraform validate
```

Review the proposed changes:

```powershell
terraform plan
```

Check managed resources:

```powershell
terraform state list
```

Confirm remote-state objects:

```powershell
aws s3 ls s3://your-terraform-state-bucket-name/lab/ --recursive
```

Expected state layout:

```text
lab/compute/terraform.tfstate
lab/network/terraform.tfstate
lab/storage/terraform.tfstate
lab/finops/terraform.tfstate
lab/workspaces/terraform.tfstate
```

---

## Standard Change Workflow

For normal infrastructure changes:

1. Update local `main` with `git pull`
2. Create a feature branch
3. Modify Terraform code
4. Run local formatting and validation
5. Commit and push the branch
6. Open a pull request
7. Review automated CI results and Terraform plan
8. Obtain peer approval
9. Merge into `main`
10. Start the protected deployment workflow
11. Review the saved Terraform plan artifact
12. Approve the protected apply job
13. Verify the apply result and run a final plan

Example Git commands:

```powershell
git switch main
git pull
git switch -c feature/example-change
git add .
git commit -m "Describe the infrastructure change"
git push -u origin feature/example-change
```

---

## What This Project Demonstrates

This project demonstrates practical Terraform, AWS, Git, and CI/CD skills:

- Infrastructure-as-Code design
- Modular Terraform structure
- Reusable modules
- Separate root stacks
- Remote S3 backend state
- State separation by workload
- S3 state locking
- AWS EC2 provisioning
- Linux and Windows workload support
- Security group management
- CloudWatch Metrics Insights alarm creation
- SNS and Lambda action integration
- AWS Budget management
- Amazon WorkSpaces Personal deployment
- AWS Directory Service-backed WorkSpaces integration
- Declarative resource import
- Standardized tagging and naming
- Feature-branch and pull-request workflow
- Automated Terraform formatting and validation
- Real Terraform plan generation in CI
- GitHub Actions artifacts
- Saved-plan review and exact-plan apply
- Protected deployment approval
- Terraform state reconciliation after AWS-side provisioning timeout
- OIDC federation between GitHub and AWS
- Short-lived AWS credentials
- Separate plan and apply IAM roles
- Least-privilege permission design
- Safe incremental infrastructure changes
- GitHub-safe handling of sensitive values
- Post-deployment state and drift verification

---

## Production Considerations

This lab implements several production-style controls, including remote state, OIDC authentication, plan/apply role separation, pull-request CI, saved-plan review, and protected deployment approval.

A larger production implementation would typically add:

- Separate AWS accounts for development, test, and production
- Centralized or versioned module registries
- Branch protection requiring independent peer approval
- Automated TFLint and Terraform security scanning
- Policy-as-code checks using tools such as OPA or Sentinel
- Cost estimation during pull requests
- Scheduled drift-detection workflows
- Centralized audit logging and alerting
- AWS KMS customer-managed encryption keys where required
- Cross-account deployment roles
- Formal change windows for production environments
- Artifact signing or stronger plan-integrity controls
- Automated post-apply validation and smoke testing

---

## Future Improvements

Planned enhancements include:

- Add TFLint and security scanning to CI
- Add automated cost estimation
- Add formal policy-as-code checks
- Add scheduled drift detection
- Add IAM role and policy modules
- Add AWS Systems Manager Session Manager access patterns
- Add additional CloudWatch alarms
- Add more FinOps resources and budget types
- Expand WorkSpaces automation to include directory/user lifecycle where appropriate
- Add automated post-apply validation
- Add architecture diagrams and dashboard screenshots
