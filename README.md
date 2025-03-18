# Website on AWS S3 with Terraform

Minimal infrastructure to set up a Single-Page Application (SPA) website on AWS. The website will run at no cost unless there is heavy traffic and it gets past the limits of the AWS Free Tier. A more detailed explanation of the code [can be found here](https://pol-santamaria.com/tech/aws-terraform-website).

- [1. Working environment](#1-working-environment)
- [2. Deploy the infrastructure](#2-deploy-the-infrastructure-basic-setup-s3--cloudfront)
  - [2.1. Issue ACM Certificate](#21-issue-acm-certificate)
  - [2.2. Create S3 bucket and CloudFront](#22-create-s3-bucket-and-cloudfront-distribution)
- [3. Debugging and next steps](#31-possible-next-steps)
  - [3.1. Possible next steps](#31-possible-next-steps)

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

- Checkout the branch [1-create-tfstate-bucket](https://github.com/polsm91/aws-terraform-website/tree/1-create-tfstate-bucket)
```bash
git fetch
git checkout 1-create-tfstate-bucket
```

- Then format (optional), initialize, and apply:
```bash
terraform fmt --recursive

terraform init

terraform apply
```

Now you have the S3 bucket ready, but the Terraform state is stored in your local machine. Let's fix it:

- Checkout the branch [2-migrate-state](https://github.com/polsm91/aws-terraform-website/tree/2-migrate-state)
```bash
git checkout 2-migrate-state
```

```bash
terraform init -migrate-state
```

- Then you can run:

```bash
$> terraform state list
module.s3.aws_s3_bucket.techyblog_tfstate
```


## 2. Deploy the infrastructure: Basic setup (S3 + CloudFront)
> **Goal**: Set up the minimal infrastructure for a simple SPA on S3, using CloudFront to speed up the serving, and HTTPS with our domain.


### 2.1. Issue ACM Certificate

- Checkout the branch [3-issue-acm-cert](https://github.com/polsm91/aws-terraform-website/tree/3-issue-acm-cert)
```bash
git checkout 3-issue-acm-cert
```

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

Afterward, If you want to monitor whether the certificate has been validated by AWS, you can do so using the AWS CLI/UI, or add the following into `acm/main.tf` and run `terraform apply`. It will perform an active wait (until Terraform timeouts) on the validation process:

```hcl
resource "aws_acm_certificate_validation" "techyblog_cert_validation" {
  certificate_arn = aws_acm_certificate.techyblog_certificate.arn
}
```

### 2.2. Create S3 bucket and CloudFront distribution

- Checkout the branch [main](https://github.com/polsm91/aws-terraform-website/tree/main)
```bash
git checkout main
```
We create a bucket to store our Single Page Application assuming the root document object will be `index.html`.

In this setup, we will limit traffic to S3 only to CloudFront. This method ensures that all requests hit CloudFront and uses its high-speed distribution network, caching, and security measures we might implement in front of CloudFront.

> **[!]** Many implementations around the internet suggest to enable the HTTP WebServer on S3 and use it as an orgin in CloudFront. I strongly discourage it, as it will create its own HTTP endpoint circumventing CloudFront. Additonally, CloudFront will redirect the HTTP requests to the webserver using the public-facing network, performing DNS resolution and all that, making the serving extremely slow and inefficient.


```bash
Outputs:

[...]
cloudfront_distribution_domain_name = "xyz.cloudfront.net"
```

You should add a new CNAME Record on your DNS that points to the output domain name (e.g.`xyz.cloudfront.net`), and after a few seconds...

> **... the website is live!**

## 3. Debugging and next steps
If you encounter issues with CloudFront, look into enabling log collection (AWS Log Group and Log Streams) which will write a file capturing the HTTP Requests received by CloudFront. If you tweak configurations, I would advise to disable caching temporarily by using this policy on CloudFront:

```hcl
data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}
```


### 3.1. Possible next steps
- Secure CloudFront with AWS WAF.
- Add a backend to serve API requests.
- Add a caching policy, `forwarded_values` was deprecated.