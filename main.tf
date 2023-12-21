terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
    backend "s3" {
    bucket = "faisalstatebucket"
    key    = "statefile"
    region = "us-east-1"
  }
}


provider "aws" {
  region     = "us-east-1"
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
}

# variable "aws_access_key" {}
# variable "aws_secret_key" {}

# data "aws_caller_identity" "current" {}

# data "aws_region" "current" {}