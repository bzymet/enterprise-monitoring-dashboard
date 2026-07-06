variable "aws_region" {
  description = "AWS region used by the provider."
  type        = string
}

variable "aws_profile" {
  description = "Optional local AWS CLI profile. Leave empty when using OIDC credentials in GitHub Actions."
  type        = string
  default     = ""
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