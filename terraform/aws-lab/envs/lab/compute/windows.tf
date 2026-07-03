locals {
  windows_server_names = [
    for n in range(var.windows_start_number, var.windows_start_number + var.windows_server_count) : format("%s%03d", var.windows_name_prefix, n)
  ]
}

module "windows_servers" {
  source = "../../../modules/ec2-instance"

  server_names         = local.windows_server_names
  ami_id               = var.windows_ami_id
  instance_type        = var.windows_instance_type
  subnet_id            = var.subnet_id
  security_group_ids   = var.windows_security_group_ids
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile

  common_tags = {
    EC2             = "true"
    Windows         = "true"
    OS              = "Windows"
    Role            = "App"
    Platform        = "EC2"
    Lambda_High_CPU = "true"
    CreatedBy       = "Terraform"
    ManagedBy       = "Terraform"
    Environment     = "Lab"
    ImageSourceName = "LAB-APP-WIN-001-golden-image"
    ImageSourceAmi  = var.windows_ami_id
  }
}