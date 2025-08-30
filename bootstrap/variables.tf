# Region to create the backend in
variable "region" {
  type = string
  description = "AWS region for the state bucket and lock table"
  default = "ca-central-1"
}

# s3 bucket name must be globally unique
variable "state_bucket_name" {
  type = string
  description = "globally unique s3 bucket name to store terraform state"
  default = "tfstate-prod-555066115752"
}

# DynamoDB table name for state locking
variable "lock_table_name" {
  type = string
  description = "DynamoDB table name used for terraform state locking."
  default = "tfstate-locks-prod"
}

variable "noncurrent_version_retention_days" {
 type =  number
  description = "How long to retain non-current state object versions"
  default = 30
}


