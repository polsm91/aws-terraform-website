# Lookup the Managed-CachingDisabled policy
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

resource "aws_cloudfront_origin_access_control" "techyblog" {
  name                              = "techyblog-oac"
  description                       = "OAC for techyblog S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "techyblog" {
  origin {
    domain_name              = var.techyblog_s3_bucket_regional_domain_name
    origin_id                = "techyblog-webui"
    origin_access_control_id = aws_cloudfront_origin_access_control.techyblog.id
  }

  default_cache_behavior {
    target_origin_id       = "techyblog-webui"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "techyblog CloudFront distribution"
  default_root_object = "index.html"
  aliases             = ["www.${var.domain_name}", "${var.domain_name}"]

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 10
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    error_caching_min_ttl = 10
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.techyblog_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
