variable "region" {
  type        = string
  description = "The deployment region"
  default     = "us-west-2"
}

variable "namespace" {
  type        = string
  description = "Your organization name or abbreviation. Eg.: ag, ya"
  default     = "yeshua"
}

variable "stage" {
  type        = string
  description = "Your cluster stage. Eg.: staging, production"
  default     = "staging"
}

variable "name" {
  type        = string
  description = "The solution name. Eg.: app, jenkins"
  default     = "app"
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "A list of CIDR blocks to use for the private subnets"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "A list of CIDR blocks to use for the public subnets"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block to apply to the full VPC"
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID"
}

variable "aws_secret_access_key_arn" {
  type        = string
  description = "ARN for the secret access key in AWS Secrets Manager"
}

