terraform {
    required_providers {
       aws= {
        source = "hashicorp/aws"
        version = "~> 5.4"
       }
    }   
}

provider "aws" {
    region = "us-east-1"
}

//S3 bucket
resource "aws_s3_bucket" "enterprise_backend_state" {
    //bucket = "dev-name-backend-state" specific
    bucket = "dev-applications-name-backend-state-lcrosendo"
    
    //lifecycle {
    //    prevent_destroy = false
    //}

    lifecycle {
        prevent_destroy = true
    }

    #force_destroy = true

    versioning {
        enabled = true
    }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "enterprise_backend_state_sse" {
    bucket = aws_s3_bucket.enterprise_backend_state.id
    
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }

}

//Locking - Dynamo DB
resource "aws_dynamodb_table" "enterprise_backend_lock" {
    name = "dev_application_locks"
    billing_mode = "PAY_PER_REQUEST"

    hash_key = "LockID"

    attribute {
        // Terraform backend name
        name = "LockID"
        // String
        type = "S"
    }
}