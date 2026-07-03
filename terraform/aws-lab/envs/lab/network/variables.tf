variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to network resources"
  type        = map(string)
  default     = {}
}

variable "linux_management_sg_name" {
  description = "Name of the Linux management security group"
  type        = string
}

variable "windows_management_sg_name" {
  description = "Name of the Windows management security group"
  type        = string
}

variable "admin_cidr_ipv4" {
  description = "Trusted admin IPv4 CIDR allowed for management access"
  type        = string
}

variable "linux_ssh_port" {
  description = "SSH port for Linux management"
  type        = number
  default     = 22
}

variable "windows_rdp_port" {
  description = "RDP port for Windows management"
  type        = number
  default     = 3389
}