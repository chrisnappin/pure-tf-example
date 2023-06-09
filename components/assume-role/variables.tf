variable "project" {
  type        = string
  description = "The name of the Project"
}

variable "build_account_id" {
  type        = string
  description = "The Build AWS Account ID"
}

variable "build_profile" {
  type        = string
  description = "The Build user profile name"
}

variable "dev_account_id" {
  type        = string
  description = "The Dev AWS Account ID"
}

variable "dev_profile" {
  type        = string
  description = "The Dev user profile name"
}

variable "test_account_id" {
  type        = string
  description = "The Test AWS Account ID"
}

variable "test_profile" {
  type        = string
  description = "The Test user profile name"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "policy_to_grant" {
  type        = string
  description = "The policy to grant to the build user"
}
