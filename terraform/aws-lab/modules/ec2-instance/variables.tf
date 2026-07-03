variable "server_names" {
  description = "List of EC2 instance names to create"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID used to create the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instances"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups assigned to the EC2 instances"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile assigned to the EC2 instances"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all EC2 instances created by this module"
  type        = map(string)
  default     = {}
}