provider "aws" {
  alias   = "build"
  profile = var.build_profile
  region  = var.region

  # The tags applied to all resources by default (unless overridden)
  default_tags {
    tags = {
      "Project" = var.project
    }
  }
}

provider "aws" {
  alias   = "dev"
  profile = var.dev_profile
  region  = var.region

  # The tags applied to all resources by default (unless overridden)
  default_tags {
    tags = {
      "Project" = var.project
    }
  }
}

provider "aws" {
  alias   = "test"
  profile = var.test_profile
  region  = var.region

  # The tags applied to all resources by default (unless overridden)
  default_tags {
    tags = {
      "Project" = var.project
    }
  }
}
