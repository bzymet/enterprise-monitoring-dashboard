module "linux_management_security_group" {
  source = "../../../modules/security-group"

  name        = var.linux_management_sg_name
  description = "Terraform-managed Linux management security group"
  vpc_id      = var.vpc_id

  ingress_rules = {
    ssh_admin = {
      description = "Allow SSH from trusted admin public IP"
      ip_protocol = "tcp"
      from_port   = var.linux_ssh_port
      to_port     = var.linux_ssh_port
      cidr_ipv4   = var.admin_cidr_ipv4
    }
  }

  egress_rules = {
    all_outbound = {
      description = "Allow all outbound traffic"
      ip_protocol = "-1"
      from_port   = -1
      to_port     = -1
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = merge(
    var.common_tags,
    {
      Platform = "Network"
      Purpose  = "LinuxManagement"
    }
  )
}

module "windows_management_security_group" {
  source = "../../../modules/security-group"

  name        = var.windows_management_sg_name
  description = "Terraform-managed Windows management security group"
  vpc_id      = var.vpc_id

  ingress_rules = {
    rdp_admin = {
      description = "Allow RDP from trusted admin public IP"
      ip_protocol = "tcp"
      from_port   = var.windows_rdp_port
      to_port     = var.windows_rdp_port
      cidr_ipv4   = var.admin_cidr_ipv4
    }
  }

  egress_rules = {
    all_outbound = {
      description = "Allow all outbound traffic"
      ip_protocol = "-1"
      from_port   = -1
      to_port     = -1
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = merge(
    var.common_tags,
    {
      Platform = "Network"
      Purpose  = "WindowsManagement"
    }
  )
}