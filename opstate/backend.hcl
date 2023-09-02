# backend.hcl
bucket = "terraops-up-and-running"
region = "us-east-2"
dynamodb_table = "terraform-up-and-running-locks"
encrypt = true