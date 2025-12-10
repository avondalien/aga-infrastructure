terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

# Role for management account Terraform assume
resource "aws_iam_role" "terraform_runner" {
  name = "TerraformRunner-${var.account_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.management_account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  description = "Role assumed by management account to run Terraform in ${var.account_name}"
}

# Role policy for management account
resource "aws_iam_role_policy" "terraform_runner_policy" {
  role = aws_iam_role.terraform_runner.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*", "kms:*", "sts:AssumeRole", "iam:PassRole"]
        Resource = "*"
      }
    ]
  })
}

# Role for GitHub Actions OIDC
resource "aws_iam_role" "github_runner" {
  name = "GitHubActionsRunner-${var.account_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.branch}"
          }
        }
      }
    ]
  })

  description = "Role assumed by GitHub Actions to deploy Terraform in ${var.account_name}"
}

# Role policy for GitHub Actions
resource "aws_iam_role_policy" "github_runner_policy" {
  role = aws_iam_role.github_runner.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*", "kms:*", "sts:AssumeRole", "iam:PassRole"]
        Resource = "*"
      }
    ]
  })
}

output "terraform_runner_role_arn" {
  value = aws_iam_role.terraform_runner.arn
}

output "github_runner_role_arn" {
  value = aws_iam_role.github_runner.arn
}