variable "environment" {
    default = "default"
}

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

resource "aws_iam_user" "my_iam_user" {
    #name = "my_iam_user_abc_updated"
    name = "${local.iam_user_extension}_${var.environment}"
}


// specific to module
locals {
    iam_user_extension = "my_iam_user_abc_updated"
}