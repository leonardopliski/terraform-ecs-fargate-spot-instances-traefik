provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tf-state-storage" {
  bucket = join("-", [var.namespace, var.stage, var.name, "terraform-state-storage"])

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Create a dynamodb table to store the current state file lock
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = join("-", [var.namespace, var.stage, var.name, "terraform-state-lock"])
  hash_key       = "LockID"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "LockID"
    type = "S"
  }
}
