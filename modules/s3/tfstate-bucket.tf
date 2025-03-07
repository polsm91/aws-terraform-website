resource "aws_s3_bucket" "techyblog_tfstate" {
  bucket = "techyblog-tfstate"

  tags = {
    project     = "techyblog"
    component   = "infra"
    environment = "dev"
  }
}
