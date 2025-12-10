# data to fetch your SSO/Identity Center instance
data "aws_ssoadmin_instances" "sso" {}

locals {
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
}

# Create a group “terraform-runners”
resource "aws_identitystore_group" "terraform_runners" {
  identity_store_id = local.identity_store_id
  display_name      = "terraform-runners"
}

# Create a user “terraform-bot”
resource "aws_identitystore_user" "terraform_bot" {
  identity_store_id = local.identity_store_id

  user_name        = "terraform-bot"
  display_name     = "Terraform Bot"

  name {
    given_name  = "Terraform"
    family_name = "Bot"
  }

  emails {
    value = "terraform-bot@aga.avondalien.com"
  }
  # you may need to supply other attributes depending on your identity store requirements
}

# Add the user to the group
resource "aws_identitystore_group_membership" "bot_membership" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.terraform_runners.group_id
  member_id         = aws_identitystore_user.terraform_bot.user_id
}

# Define the Permission Set
resource "aws_ssoadmin_permission_set" "terraform_runner" {
  name        = "TerraformRunner"
  description = "Permission set for Terraform deployments in a single account"
  instance_arn = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  session_duration = "PT1H"
}

# Attach policies (either AWS-managed or custom inline). Example: AdministratorAccess for now
resource "aws_ssoadmin_managed_policy_attachment" "terraform_runner_admin" {
  instance_arn        = aws_ssoadmin_permission_set.terraform_runner.instance_arn
  permission_set_arn  = aws_ssoadmin_permission_set.terraform_runner.arn
  managed_policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# For each account where Terraform operates (dev, prod), assign the permission set to the group
resource "aws_ssoadmin_account_assignment" "terraform_dev" {
  instance_arn        = aws_ssoadmin_permission_set.terraform_runner.instance_arn
  target_id           = aws_organizations_account.dev_account.id # devAccount ID
  target_type         = "AWS_ACCOUNT"
  principal_type      = "GROUP"
  principal_id        = aws_identitystore_group.terraform_runners.group_id
  permission_set_arn  = aws_ssoadmin_permission_set.terraform_runner.arn
}

resource "aws_ssoadmin_account_assignment" "terraform_prod" {
  instance_arn        = aws_ssoadmin_permission_set.terraform_runner.instance_arn
  target_id           = aws_organizations_account.prod_account.id  # prodAccount ID
  target_type         = "AWS_ACCOUNT"
  principal_type      = "GROUP"
  principal_id        = aws_identitystore_group.terraform_runners.group_id
  permission_set_arn  = aws_ssoadmin_permission_set.terraform_runner.arn
}
