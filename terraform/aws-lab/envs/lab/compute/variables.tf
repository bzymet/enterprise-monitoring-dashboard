variable "subnet_id" {
  description = "Subnet ID for EC2 instances"
  type        = string
}

variable "linux_security_group_ids" {
  description = "Security groups assigned to Linux EC2 instances"
  type        = list(string)
}

variable "windows_security_group_ids" {
  description = "Security groups assigned to Windows EC2 instances"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile assigned to EC2 instances"
  type        = string
}

variable "linux_ami_id" {
  description = "AMI ID used to create Linux EC2 instances"
  type        = string
}

variable "linux_instance_type" {
  description = "Linux EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "linux_name_prefix" {
  description = "Naming prefix for Linux EC2 instances"
  type        = string
  default     = "LAB-APP-LNX-"
}

variable "linux_start_number" {
  description = "Starting number for Linux EC2 instance names"
  type        = number
  default     = 2
}

variable "linux_server_count" {
  description = "Number of Linux EC2 instances to create"
  type        = number
  default     = 1
}

variable "windows_ami_id" {
  description = "AMI ID used to create Windows EC2 instances"
  type        = string
}

variable "windows_instance_type" {
  description = "Windows EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "windows_name_prefix" {
  description = "Naming prefix for Windows EC2 instances"
  type        = string
  default     = "LAB-APP-WIN-"
}

variable "windows_start_number" {
  description = "Starting number for Windows EC2 instance names"
  type        = number
  default     = 3
}

variable "windows_server_count" {
  description = "Number of Windows EC2 instances to create"
  type        = number
  default     = 0
}

variable "common_tags" {
  description = "Common tags applied to compute stack resources"
  type        = map(string)
  default     = {}
}

variable "ec2_fleet_high_cpu_alarm_name" {
  description = "Name of the EC2 fleet high CPU CloudWatch alarm"
  type        = string
}

variable "ec2_fleet_high_cpu_alarm_description" {
  description = "Description of the EC2 fleet high CPU CloudWatch alarm"
  type        = string
}

variable "ec2_fleet_high_cpu_comparison_operator" {
  description = "Comparison operator for the EC2 fleet high CPU alarm"
  type        = string
  default     = "GreaterThanThreshold"
}

variable "ec2_fleet_high_cpu_evaluation_periods" {
  description = "Number of evaluation periods for the EC2 fleet high CPU alarm"
  type        = number
  default     = 1
}

variable "ec2_fleet_high_cpu_datapoints_to_alarm" {
  description = "Number of breaching datapoints required to trigger the EC2 fleet high CPU alarm"
  type        = number
  default     = 1
}

variable "ec2_fleet_high_cpu_threshold" {
  description = "CPU threshold percentage for the EC2 fleet high CPU alarm"
  type        = number
}

variable "ec2_fleet_high_cpu_treat_missing_data" {
  description = "How CloudWatch treats missing data for the EC2 fleet high CPU alarm"
  type        = string
  default     = "missing"
}

variable "ec2_fleet_high_cpu_actions_enabled" {
  description = "Whether CloudWatch alarm actions are enabled"
  type        = bool
  default     = true
}

variable "ec2_fleet_high_cpu_alarm_actions" {
  description = "List of action ARNs triggered when the EC2 fleet high CPU alarm enters ALARM state"
  type        = list(string)
}

variable "ec2_fleet_high_cpu_metric_query_id" {
  description = "Metric query ID for the EC2 fleet high CPU alarm"
  type        = string
  default     = "q1"
}

variable "ec2_fleet_high_cpu_metric_query_expression" {
  description = "CloudWatch Metrics Insights expression for EC2 fleet high CPU detection"
  type        = string
}

variable "ec2_fleet_high_cpu_period" {
  description = "Metric query period in seconds"
  type        = number
  default     = 300
}