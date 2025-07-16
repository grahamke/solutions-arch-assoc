# This is a similar budget created in the budget-limit stack
resource "aws_budgets_budget" "ten_bucks" {
  name         = "My Monthly Cost Budget (${var.budget_limit_amount})"
  budget_type  = "COST"
  limit_amount = var.budget_limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
  notification {
    notification_type          = "ACTUAL"
    comparison_operator        = "GREATER_THAN"
    threshold                  = "85"
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.budget_email_address]
  }

  notification {
    notification_type          = "ACTUAL"
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.budget_email_address]
  }

  notification {
    notification_type          = "FORECASTED"
    comparison_operator        = "GREATER_THAN"
    threshold                  = "100"
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.budget_email_address]
  }
}