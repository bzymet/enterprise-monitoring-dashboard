resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.datapoints_to_alarm
  threshold           = var.threshold
  treat_missing_data  = var.treat_missing_data
  actions_enabled     = var.actions_enabled

  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  metric_query {
    id          = var.metric_query_id
    expression  = var.metric_query_expression
    return_data = true
    period      = var.period
  }

  tags = var.tags
}