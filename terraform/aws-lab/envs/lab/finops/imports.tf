import {
  to = aws_budgets_budget.zero_spend
  id = "${data.aws_caller_identity.current.account_id}:${var.budget_name}"
}
