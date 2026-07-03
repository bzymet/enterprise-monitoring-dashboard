output "linux_management_security_group_id" {
  description = "ID of the Terraform-managed Linux management security group"
  value       = module.linux_management_security_group.security_group_id
}

output "linux_management_security_group_name" {
  description = "Name of the Terraform-managed Linux management security group"
  value       = module.linux_management_security_group.security_group_name
}

output "windows_management_security_group_id" {
  description = "ID of the Terraform-managed Windows management security group"
  value       = module.windows_management_security_group.security_group_id
}

output "windows_management_security_group_name" {
  description = "Name of the Terraform-managed Windows management security group"
  value       = module.windows_management_security_group.security_group_name
}