output "workspace_id" {
  description = "ID of the deployed Amazon WorkSpace"
  value       = module.personal_workspace.workspace_id
}

output "workspace_ip_address" {
  description = "Private IP address assigned to the WorkSpace"
  value       = module.personal_workspace.workspace_ip_address
}

output "workspace_state" {
  description = "Current state of the WorkSpace"
  value       = module.personal_workspace.workspace_state
}
