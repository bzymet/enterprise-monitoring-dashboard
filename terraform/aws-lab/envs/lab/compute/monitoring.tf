# CI validation test - no infrastructure change

module "ec2_fleet_high_cpu_alarm" {
  source = "../../../modules/cloudwatch-metric-alarm"

  alarm_name        = var.ec2_fleet_high_cpu_alarm_name
  alarm_description = var.ec2_fleet_high_cpu_alarm_description

  comparison_operator = var.ec2_fleet_high_cpu_comparison_operator
  evaluation_periods  = var.ec2_fleet_high_cpu_evaluation_periods
  datapoints_to_alarm = var.ec2_fleet_high_cpu_datapoints_to_alarm
  threshold           = var.ec2_fleet_high_cpu_threshold
  treat_missing_data  = var.ec2_fleet_high_cpu_treat_missing_data
  actions_enabled     = var.ec2_fleet_high_cpu_actions_enabled

  alarm_actions = var.ec2_fleet_high_cpu_alarm_actions

  metric_query_id         = var.ec2_fleet_high_cpu_metric_query_id
  metric_query_expression = var.ec2_fleet_high_cpu_metric_query_expression
  period                  = var.ec2_fleet_high_cpu_period

  tags = merge(
    var.common_tags,
    {
      Name     = var.ec2_fleet_high_cpu_alarm_name
      Platform = "CloudWatch"
      Purpose  = "HighCPURemediation"
    }
  )
}