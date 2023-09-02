provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraops-up-and-running"

  #Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
  
}

#Enable versioning so we can see the full revision history of our state files
resource "aws_s3_bucket_versioning" "state-version" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

#Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "state-encrypt" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    key = "global/s3/terraform.tfstate"
    
  }
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.terraform_state.arn
    description = "The ARN of the S3 bucket"
  
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform_locks.name
    description = "The name of the DynamoDB table"
  
}