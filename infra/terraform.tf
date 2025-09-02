terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "tfstate-prod-555066115752"
    key            = "aws-vpc-ec2-for-k8s/prod/terraform.tfstate" # path file name in s3
    region         = "ca-central-1"
    dynamodb_table = "tfstate-locks-prod"
    encrypt        = true
  }
}
