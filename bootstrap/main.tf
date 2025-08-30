provider "aws" {
  region = var.region
}


# S3 bucket that will hold terraform.ftstate
resource "aws_s3_bucket" "tf_state" {
  bucket = var.state_bucket_name

  # Helpful tags for auditing
  tags = {
    Name        = "terraform-state"
    ManagedBy   = "terraform"
    Purpose     = "remote-state"
    Environment = "prod"
  }
}

## Block all public access
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Turn on versioning so each state writes keeps an old version for recovery
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
# server side encryption no KMS key needed
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# prune old non current versions for cost control
resource "aws_s3_bucket_lifecycle_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    id     = "retain-noncurrent-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_retention_days
    }
    filter {}
  }


  depends_on = [aws_s3_bucket_versioning.tf_state]
}

# ================ Dynamo Table for Terraform state locking ==================================================
resource "aws_dynamodb_table" "tf_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-locks"
    ManagedBy   = "terraform"
    Purpose     = "state-locking"
    Environment = "prod"
  }
}
