terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key = "base/terraform.tfstate"
  }

  required_version = ">= 1.4.0"
}
