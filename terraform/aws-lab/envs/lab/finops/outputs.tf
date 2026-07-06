output "budget_name" {
  description = "Name of the AWS Budget managed by the FinOps stack."
  value       = aws_budgets_budget.zero_spend.name
}

output "budget_id" {
  description = "Terraform and AWS identifier for the managed budget."
  value       = aws_budgets_budget.zero_spend.id
}