output "linux_instance_ids" {
  value = module.linux_servers.instance_ids
}

output "linux_private_ips" {
  value = module.linux_servers.private_ips
}

output "linux_public_ips" {
  value = module.linux_servers.public_ips
}

output "windows_instance_ids" {
  value = module.windows_servers.instance_ids
}

output "windows_private_ips" {
  value = module.windows_servers.private_ips
}

output "windows_public_ips" {
  value = module.windows_servers.public_ips
}

output "ec2_fleet_high_cpu_alarm_name" {
  description = "Name of the Terraform-managed EC2 fleet high CPU CloudWatch alarm"
  value       = module.ec2_fleet_high_cpu_alarm.alarm_name
}

output "ec2_fleet_high_cpu_alarm_arn" {
  description = "ARN of the Terraform-managed EC2 fleet high CPU CloudWatch alarm"
  value       = module.ec2_fleet_high_cpu_alarm.alarm_arn
}