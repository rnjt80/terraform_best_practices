terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }

    backend "s3" { # Example: S3 backend for dev
        bucket  = "your-dev-terraform-state-bucket"
        key     = "dev/terraform.tfstate"
        region  = "your-aws-region"
        # encrypt = true # Recommended
        # use_lockfile = true # Can use native state locking within S3 for Terraform 1.10 and later
        dynamodb_table = "your-dev-state-lock-table" # Add DynamoDB table for locking
    }
}

provider "aws" {
region = "your-aws-region" # Replace with your desired AWS region
}