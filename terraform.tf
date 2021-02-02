terraform {
  required_version = ">= 0.14.5"

  backend "s3" {
    encrypt        = true
    region         = "us-west-2"
    bucket         = "yeshua-app-terraform-state-storage"
    dynamodb_table = "yeshua-app-terraform-state-lock"
    key            = "terraform.tfstate"
  }
}
