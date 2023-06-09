# The default AWS provider
provider "aws" {
  region = var.region

  # For no reason other than redundant safety
  # we only allow the use of the AWS Account
  # specified in the environment variables.
  # This helps to prevent accidents.
  allowed_account_ids = [
    var.aws_account_id,
  ]

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/provision_role"
  }

  # The tags applied to all resources by default (unless overridden)
  default_tags {
    tags = {
      "Project"     = var.project
      "Environment" = local.environment
    }
  }
}
