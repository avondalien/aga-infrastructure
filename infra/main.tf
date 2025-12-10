provider "aws" {
  region  = "us-east-2"

  default_tags {
    tags = {
      Environment = var.environment
      SourceRepo  = "aws-infrastructure"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"

  default_tags {
    tags = {
      Environment = var.environment
      SourceRepo  = "aws-infrastructure"
    }
  }
}

module "dns" {
  source = "./modules/dns"
  hosted_zone = var.hosted_zone
}

module "certificate" {
  source = "./modules/certificates"
  hosted_zone = module.dns.hosted_zone
  hosted_zone_id = module.dns.hosted_zone_id
  providers = {
    aws.home = aws
    aws.us_east_1 = aws.us_east_1
  }
}

// This is temporary until static site hosting is set up

resource "aws_route53_record" "initial_record_root" {
  zone_id = module.dns.hosted_zone_id
  name    = module.dns.hosted_zone
  type    = "A"
  ttl     = 300
  records = ["192.0.2.1"]
}

// Static site hosting here


// Auth server

module "auth" {
  source = "./modules/auth"
  depends_on = [ aws_route53_record.initial_record_root ]
  sites_with_auth = var.sites_with_auth
  auth_domain_name = "auth.${module.dns.hosted_zone}"
  hosted_zone_certificate_arn = module.certificate.certificate_arn
  user_pool_name = "aga-members"
  auth_group_names = [ "members", "admins" ]
  custom_login_image = filebase64("assets/aga.png")
  hosted_zone_id = module.dns.hosted_zone_id
}