<p align="center">
  <h3 align="center">Terraform AWS - ECS Fargate Spot Instances, Networking & Traefik</h3>
</p>

## Table of Contents

- [About the Project](#about-the-project)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)

## About The Project

There are many issues involved when creating new project infrastructures.

Here's why:

- It's difficult to handle projects maintenance when there's no codified infrastructure, you don't know what and how much resources are being used.
- Cross development gets harder since there's no idea about how the application infrastructure work.
- The process of manually creating your infrastructure takes so much time.
- It's difficult to create an infrastructure cost prediction.

Due to these issues, Terraform is an IaC (Infrastructure as Code) tool to automate your setup.

## Getting Started

To get your infrastructure up and running follow the steps:

### Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) configured with an administrator [IAM user](https://aws.amazon.com/iam/) credential.

```sh
aws configure
```

- Create an AWS Secrets Manager secret to store your AWS secret access key, and grab its ARN.

- [Terraform v0.14.5](https://www.terraform.io/downloads.html)

- Check the `fixtures.staging.us-west-2.tfvars` file variables, and set them according to your environment. Or create one file for another environment :).

### Usage

1. Go to the `remote-state` folder and initialize your remote state using AWS S3 and DynamoDB. (Optional, but recommended).

```sh
terraform init
terraform apply -var-file=../fixtures.staging.us-west-2.tfvars
```

2. Install all modules required by this configuration.

```sh
cd ../
terraform init
```

3. Apply your infrastructure based on environment variables. (Check `variables.tf` and create a terraform tfstate file if necessary)

```sh
terraform apply -var-file=fixtures.staging.us-west-2.tfvars
```

3. (Optional) - If you want to estimate your infrastructure costs, so you may generate a terraform plan and analyze it with [terraform cost estimation](https://terraform-cost-estimation.com/)

```sh
terraform plan -var-file=fixtures.staging.us-west-2.tfvars  -out=plan.tfplan && terraform show -json plan.tfplan > plan.json
```
