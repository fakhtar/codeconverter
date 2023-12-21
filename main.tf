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
}
 resource "aws_s3_bucket" "sample" {
   
 }