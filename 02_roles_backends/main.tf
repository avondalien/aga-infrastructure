provider "aws" {
  region = var.region
}

provider "aws" {
    alias = "dev"
    region = var.region

    assume_role {
        role_arn = "arn:aws:iam::${var.accounts["dev"].id}:role/OrganizationAccountAccessRole"
    }
}

provider "aws" {
  alias  = "prod"
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.accounts["prod"].id}:role/OrganizationAccountAccessRole"
  }
}

/*
module "terraform_runner_dev" {
  source = "./modules/terraform_runner"

  providers = { aws = aws.dev }

  account_name           = "dev"
  account_id = var.accounts["dev"].id
  management_account_id  = var.accounts["management"].id  # your management account ID
  github_org = var.github.org
  github_repo = var.github.repo
  branch = var.github.branch
}
*/

module "remote_state_dev" {
  source = "./modules/terraform_backend"

  providers = { aws = aws.dev }

  account_name = "dev"
}

# Prod account
/*
module "terraform_runner_prod" {
  source = "./modules/terraform_runner"

  providers = { aws = aws.prod }

  account_name          = "prod"
  account_id = var.accounts["prod"].id
  management_account_id = var.accounts["management"].id  
  github_org = var.github.org
  github_repo = var.github.repo
  branch = var.github.branch
}
*/

module "remote_state_prod" {
  source = "./modules/terraform_backend"

  providers = { aws = aws.prod }

  account_name = "prod"
}