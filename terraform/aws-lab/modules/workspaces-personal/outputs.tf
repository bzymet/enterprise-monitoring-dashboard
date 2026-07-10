output "workspace_id" {
  description = "ID of the Amazon WorkSpace"
  value       = aws_workspaces_workspace.this.id
}

output "workspace_ip_address" {
  description = "IP address assigned to the Amazon WorkSpace"
  value       = aws_workspaces_workspace.this.ip_address
}

output "workspace_state" {
  description = "Current state of the Amazon WorkSpace"
  value       = aws_workspaces_workspace.this.state
}
