module "acm" {
  source = "./modules/acm"
  domain_name = var.domain_name
}

module "s3" {
  source = "./modules/s3"
}


# Domain name for our website
variable "domain_name" {
  type = string
}


# Records to add to the Nameserver
output "certificate_validation_name" {
  value = module.acm.certificate_validation_name
}

output "certificate_validation_records" {
  value = module.acm.certificate_validation_records
}
