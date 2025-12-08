provider "aws" {
    region = "us-east-2"

    default_tags {
        tags = {
            Environment = "global"
            SourceRepo = "aga-infra/bootstrap"
        }
    }
}

data "aws_organizations_organization" "org" {}

resource "aws_organizations_organizational_unit" "homepage" {
    name = "Homepage"
    parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "prod" {
    name = "prod"
    parent_id = aws_organizations_organizational_unit.homepage.id
}

resource "aws_organizations_organizational_unit" "dev" {
    name = "dev"
    parent_id = aws_organizations_organizational_unit.homepage.id
}

resource "aws_organizations_account" "prod_account" {    
    name = "prodaccount"
    email = "prod@aga.avondalien.com"
    parent_id = aws_organizations_organizational_unit.prod.id
    role_name = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "dev_account" {    
    name = "devaccount"
    email = "dev@aga.avondalien.com"
    parent_id = aws_organizations_organizational_unit.dev.id
    role_name = "OrganizationAccountAccessRole"
}
