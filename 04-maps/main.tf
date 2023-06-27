variable "users" {
  default = {
    ravs : { country : "Netherlands", department = "abc" },
    tom : { country : "US", department = "zxc" },
    jane : { country : "India", department = "def" }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }
}
