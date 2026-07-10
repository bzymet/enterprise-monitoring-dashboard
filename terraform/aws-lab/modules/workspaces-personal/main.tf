resource "aws_workspaces_workspace" "this" {
  directory_id = var.directory_id
  bundle_id    = var.bundle_id
  user_name    = var.user_name

  root_volume_encryption_enabled = var.root_volume_encryption_enabled
  user_volume_encryption_enabled = var.user_volume_encryption_enabled

  workspace_properties {
    compute_type_name                         = "STANDARD"
    root_volume_size_gib                      = 80
    user_volume_size_gib                      = 50
    running_mode                              = var.running_mode
    running_mode_auto_stop_timeout_in_minutes = var.auto_stop_timeout_minutes
  }

  tags = var.tags
}
