# Steps

## Phase 1: Setup

> **Goal**: Setup the working environment and create an S3 bucket to store the Terraform State.

Create the S3 Bucket to hold the Terraform State:
```bash
aws sso login --profile admin-iam-sso
```

Add the following on .bashrc (quick fix):
```bash
alias terraform="AWS_PROFILE=admin-iam-sso terraform"
```

Then format, initialize and apply:
```bash
terraform fmt --recursive

terraform init

terraform apply
```


### Migrate the state

```bash
terraform init -migrate-state
```

Then you can run:
```bash
$> terraform state list
module.s3.aws_s3_bucket.techyblog_tfstate
```


## Phase 2: Basic infra setup (S3+CloudFront)
> **Goal**: Setup the minimal infrastructure for a simple SPA on S3, using CloudFront to speedup the serving, and HTTPS with our domain.


### 1: Issue ACM Certificate

```bash
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

certificate_validation_name = "XXXXXX.com."
certificate_validation_records = [
  "YYYYYY.acm-validations.aws.",
]
certificate_validation_type = "CNAME"
```