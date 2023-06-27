variable "application_name" {
    default = "07-backend-state"
}

variable "project_name" {
    default = "users"
}

variable "environment_name" {
    default = "dev"
}

terraform {
    required_providers {
       aws= {
        source = "hashicorp/aws"
        version = "~> 5.4"
       }
    }   

    backend "s3" {
        bucket = "dev-applications-name-backend-state-lcrosendo"
        // app - env - prj
        // broken
        //key = "${var.application_name}-${var.project_name}-${var.environment_name}"
        //key = "07-backend-state-users-dev"
        key = "dev/07-backend-state/users/backend-state"
        region = "us-east-1"
        dynamodb_table = "dev_application_locks"
        encrypt = true
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
    name = "${terraform.workspace}_my_iam_user_abc_updated"
}