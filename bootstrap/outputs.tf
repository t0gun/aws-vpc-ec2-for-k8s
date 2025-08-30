# S3 bucket name to plug into backend config
output "state_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
  description = "S3 bucket for Terraform remote state"
}

# DynamoDB table for state locking
output "lock_table_name" {
  value = aws_dynamodb_table.tf_locks.name
  description = "Dynamo table for terraform state locking"
}