output "instance_ids" {
  value = {
    for name, instance in aws_instance.this : name => instance.id
  }
}

output "private_ips" {
  value = {
    for name, instance in aws_instance.this : name => instance.private_ip
  }
}

output "public_ips" {
  value = {
    for name, instance in aws_instance.this : name => instance.public_ip
  }
}