# -----------------------------
# Remote state buckets
# -----------------------------
output "remote_state_dev_bucket" {
  description = "S3 bucket for Terraform remote state in dev account"
  value       = module.remote_state_dev.bucket_name
}

output "remote_state_prod_bucket" {
  description = "S3 bucket for Terraform remote state in prod account"
  value       = module.remote_state_prod.bucket_name
}

# -----------------------------
# Optional: account IDs (useful for scripts)
# -----------------------------
output "dev_account_id" {
  description = "AWS account ID for dev"
  value       = var.accounts["dev"].id
}

output "prod_account_id" {
  description = "AWS account ID for prod"
  value       = var.accounts["prod"].id
}