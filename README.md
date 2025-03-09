# Website on AWS S3 with Terraform

Minimal infrastructure to set up a Single Page Appliaction (SPA) website on AWS. The website will run at no cost unless there is heavy traffic and it gets past the limits of the AWS Free Tier.

# Steps

## 1. Working environment

> **Goal**: Setup the working environment and create an S3 bucket to store the Terraform State.

- Create the S3 Bucket to hold the Terraform State, and replace `your-aws-profile` with your AWS profile:
```bash
aws sso login --profile your-aws-profile
```

- Add the following on .bashrc (quick fix):
```bash
alias terraform="AWS_PROFILE=your-aws-profile terraform"
```

- Then format, initialize and apply:
```bash
terraform fmt --recursive

terraform init

terraform apply
```

Now you have the S3 bucket ready, but the Terraform state is stored in your local machine. Let's fix it:

```bash
terraform init -migrate-state
```

- Then you can run:

```bash
$> terraform state list
module.s3.aws_s3_bucket.techyblog_tfstate
```


## 2. Deploy the infrastructure: Basic setup (S3 + CloudFront)
> **Goal**: Setup the minimal infrastructure for a simple SPA on S3, using CloudFront to speed up the serving, and HTTPS with our domain.


### 2.1. Issue ACM Certificate

You will be prompted to fill in the domain name. Each time you apply the plan the question will pop up, so I recommend editing the file `main.tf` to add a default value to the variable such as:

```hcl
# Domain name for our website
variable "domain_name" {
  type = string
  default = "mydomain.com"
}
```

After applying, you will get your certificate validation records:

```bash
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:
certificate_validation_name = "XXXXX.com."

certificate_validation_records = [
  "YYYYYY.acm-validations.aws.",
]
```

Add the `certificate_validation_name` and `certificate_validation_records` as a CNAME record in your nameserver (e.g. Namecheap, GoDaddy, AWS Route 53,...).

Afterwards, If you want to monitor whether the certificate has been validated by AWS, you can do so using the AWS CLI/UI, or add the following into `acm/main.tf` and run `terraform apply`. It will perform an active wait (until Terraform timeouts) on the validation process:

```hcl
resource "aws_acm_certificate_validation" "techyblog_cert_validation" {
  certificate_arn = aws_acm_certificate.techyblog_certificate.arn
}
```
