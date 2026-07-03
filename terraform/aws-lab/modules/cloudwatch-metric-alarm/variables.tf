variable "alarm_name" {
  description = "Name of the CloudWatch metric alarm"
  type        = string
}

variable "alarm_description" {
  description = "Description of the CloudWatch metric alarm"
  type        = string
  default     = null
}

variable "comparison_operator" {
  description = "Comparison operator used by the alarm"
  type        = string
}

variable "evaluation_periods" {
  description = "Number of evaluation periods used by the alarm"
  type        = number
}

variable "datapoints_to_alarm" {
  description = "Number of datapoints that must breach to trigger the alarm"
  type        = number
}

variable "threshold" {
  description = "Threshold value for the alarm"
  type        = number
}

variable "treat_missing_data" {
  description = "How CloudWatch treats missing data"
  type        = string
  default     = "missing"
}

variable "actions_enabled" {
  description = "Whether alarm actions are enabled"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "Actions to execute when the alarm enters ALARM state"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "Actions to execute when the alarm enters OK state"
  type        = list(string)
  default     = []
}

variable "insufficient_data_actions" {
  description = "Actions to execute when the alarm enters INSUFFICIENT_DATA state"
  type        = list(string)
  default     = []
}

variable "metric_query_id" {
  description = "CloudWatch metric query ID"
  type        = string
  default     = "q1"
}

variable "metric_query_expression" {
  description = "CloudWatch Metrics Insights or metric math expression"
  type        = string
}

variable "period" {
  description = "Metric query period in seconds"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags applied to the CloudWatch alarm"
  type        = map(string)
  default     = {}
}