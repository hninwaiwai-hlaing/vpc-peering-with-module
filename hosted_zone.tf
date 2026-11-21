module "public_zone" {
  source  = "terraform-aws-modules/route53/aws"
  version = "~> 6.0"

  providers = {
    aws = aws.tokyo
  }

  name    = var.public_hosted_zone
  comment = var.public_hosted_zone_comment

  records = {
    customer_profile = {
      name = "peering-module"
      type = "A"
      alias = {
        name    = module.customer_profile_alb.dns_name
        zone_id = module.customer_profile_alb.zone_id
      }
    }
  }
}
output "public_zone_name_servers" {
  value = module.public_zone.name_servers
}