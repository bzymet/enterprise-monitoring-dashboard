module "personal_workspace" {
  source = "../../../modules/workspaces-personal"

  directory_id = var.directory_id
  bundle_id    = var.bundle_id
  user_name    = var.user_name

  tags = {
    Name        = "LAB-WORKSPACE-WIN-001"
    Environment = "Lab"
    ManagedBy   = "Terraform"
    Project     = "Enterprise-Monitoring-Dashboard"
  }
}
