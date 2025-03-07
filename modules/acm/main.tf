## Certificate for Application Load Balancer including validation via CNAME record

resource "aws_acm_certificate" "techyblog_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    project     = "techyblog"
    component   = "infra"
    environment = "dev"
  }
}
