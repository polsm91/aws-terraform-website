module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
}


module "cloudfront" {
  source                                   = "./modules/cloudfront"
  domain_name                              = var.domain_name
  techyblog_s3_bucket_regional_domain_name = module.s3.techyblog_s3_bucket_regional_domain_name
  techyblog_certificate_arn                = module.acm.acm_certificate_arn
}


module "s3" {
  source                                    = "./modules/s3"
  techyblog_aws_cloudfront_distribution_arn = module.cloudfront.techyblog_aws_cloudfront_distribution_arn
}


# Variables

variable "domain_name" {
  description = "Domain name for our website"
  type = string
}


# Outputs
output "certificate_validation_name" {
  description = "Host record to add to the Nameserver to validate the certificate"
  value = module.acm.certificate_validation_name
}

output "certificate_validation_records" {
  description = "Value record to add to the Nameserver to validate the certificate"
  value = module.acm.certificate_validation_records
}

output "cloudfront_distribution_domain_name" {
  description = "Value record to add to the Nameserver to serve the website from CloudFront"
  value = module.cloudfront.techyblog_cloudfront_domain_name
}
