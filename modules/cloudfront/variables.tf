variable "domain_name" {
  description = "Domain name for our website"
  type = string
}

variable "techyblog_s3_bucket_regional_domain_name" {
  description = "Regional Domain Name of the S3 serving the UI website"
  type        = string
}

variable "techyblog_certificate_arn" {
  description = "ARN of the Certificate issued to secure web traffic to the UI"
  type        = string
}
