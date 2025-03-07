
## We only need one record for the DNS validation for both certificates, as records are the same for all regions
output "certificate_validation_name" {
  value = tolist(aws_acm_certificate.techyblog_certificate.domain_validation_options)[0].resource_record_name
}

output "certificate_validation_type" {
  value = tolist(aws_acm_certificate.techyblog_certificate.domain_validation_options)[0].resource_record_type
}

output "certificate_validation_records" {
  value = [tolist(aws_acm_certificate.techyblog_certificate.domain_validation_options)[0].resource_record_value]
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.techyblog_certificate.arn
}
