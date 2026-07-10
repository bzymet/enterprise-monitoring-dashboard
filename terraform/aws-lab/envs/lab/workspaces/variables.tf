variable "aws_region" {
  description = "AWS region where the WorkSpace is deployed"
  type        = string
}

variable "aws_profile" {
  description = "Local AWS CLI profile; empty when GitHub Actions uses OIDC"
  type        = string
  default     = ""
}

variable "directory_id" {
  description = "ID of the registered AWS Directory Service directory"
  type        = string
}

variable "bundle_id" {
  description = "ID of the Amazon WorkSpaces bundle"
  type        = string
}

variable "user_name" {
  description = "Directory user assigned to the WorkSpace"
  type        = string
}