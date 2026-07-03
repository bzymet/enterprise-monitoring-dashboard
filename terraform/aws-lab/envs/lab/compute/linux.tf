locals {
  linux_server_names = [
    for n in range(var.linux_start_number, var.linux_start_number + var.linux_server_count) : format("%s%03d", var.linux_name_prefix, n)
  ]
}

module "linux_servers" {
  source = "../../../modules/ec2-instance"

  server_names         = local.linux_server_names
  ami_id               = var.linux_ami_id
  instance_type        = var.linux_instance_type
  subnet_id            = var.subnet_id
  security_group_ids   = var.linux_security_group_ids
  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile

  common_tags = {
    EC2                   = "true"
    Linux                 = "true"
    OS                    = "Linux"
    Role                  = "App"
    Platform              = "EC2"
    Lambda_High_CPU_Linux = "true"
    CreatedBy             = "Terraform"
    ManagedBy             = "Terraform"
    Environment           = "Lab"
    ImageSourceName       = "LAB-APP-LNX-001-terraform-clone-image"
    ImageSourceAmi        = var.linux_ami_id
  }
}