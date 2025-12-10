resource "aws_budgets_budget" "account_budget" {
  for_each = local.accounts

  name              = "${each.key}-monthly-budget"
  budget_type       = "COST"
  limit_amount      = var.budget_notifications_threshold
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  # Monitor spend for the specified linked account
  cost_filter {
    name = "LinkedAccount"
    values = [each.value]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.budget_notifications_emails
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 100
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.budget_notifications_emails
  }
}