variable "aws_region" {
  description = "AWS region used by the provider."
  type        = string
}

variable "aws_profile" {
  description = "Local AWS CLI profile used when running Terraform from a workstation."
  type        = string
}

variable "budget_name" {
  description = "Name of the AWS Budget managed by this stack."
  type        = string
}

variable "budget_limit_amount" {
  description = "Monthly budget limit in USD."
  type        = number
}

variable "notification_email" {
  description = "Email address that receives AWS Budget notifications."
  type        = string
  sensitive   = true
}