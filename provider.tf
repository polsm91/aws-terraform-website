terraform {
  required_version = "1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "techyblog-tfstate"
    key    = "tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "admin-iam-sso"
}
