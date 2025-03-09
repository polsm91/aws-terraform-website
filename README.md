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
