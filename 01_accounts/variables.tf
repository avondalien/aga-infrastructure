variable "budget_notifications_emails" {
  type        = list(string)
  description = "Email address that receives cost alerts"
}

variable "budget_notifications_threshold" {
    type = string
    description = "Whole dollar value of when to send the budget warning email"
}