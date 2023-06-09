terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key     = "assume-role/terraform.tfstate"
  }

  required_version = ">= 1.4.0"
}
