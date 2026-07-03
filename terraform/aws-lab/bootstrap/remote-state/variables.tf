variable "state_bucket_name" {
  description = "Name of the S3 bucket used for Terraform remote state"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to Terraform backend resources"
  type        = map(string)
  default     = {}
}