variable "account_name" {
  type        = string
  description = "Name of the target AWS account (dev, prod, etc.)"
}

variable "account_id" {
  type        = string
  description = "AWS account ID of the target account"
}

variable "management_account_id" {
  type        = string
  description = "AWS account ID of the management account"
}

variable "github_org" {
  type        = string
  description = "GitHub organization owning the repository"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
}

variable "branch" {
  type        = string
  description = "Git branch allowed to assume the GitHub Actions role"
  default     = "main"
}