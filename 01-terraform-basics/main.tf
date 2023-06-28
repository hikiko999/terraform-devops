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

# plan - execute
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-s3-bucket-lcrosendo-terra-2"
    versioning {
        enabled = true
    }
}

resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user_abc_updated"
}