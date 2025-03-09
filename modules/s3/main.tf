resource "aws_s3_bucket" "techyblog_webui" {
  bucket = "techyblog-webui"

  tags = {
    project     = "techyblog"
    component   = "infra"
    environment = "dev"
  }
}



resource "aws_s3_bucket_website_configuration" "techyblog_webui" {
  bucket = aws_s3_bucket.techyblog_webui.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "techyblog_webui" {
  bucket                  = aws_s3_bucket.techyblog_webui.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "techyblog_webui" {
  bucket = aws_s3_bucket.techyblog_webui.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.techyblog_webui.id}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.techyblog_aws_cloudfront_distribution_arn
          }
        }
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.techyblog_webui]
}
