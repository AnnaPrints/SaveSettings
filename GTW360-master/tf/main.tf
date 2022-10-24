terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    key = "gtw-360/terraform.tfstate"
    bucket          = "jb-gtw360-tfstate"
    region          = "eu-north-1"
    dynamodb_table  = "jb-gtw360-tf-locks"
    encrypt         = true
  }
}

provider "aws" {
  profile = "sandbox"
  region  = "eu-north-1"
}