variable "name" {
  type        = string
  description = "The subnet name (prefix)"
}

variable "availability_zones" {
  type        = list(string)
  description = "The AWS AZs to use"
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block of the VPC"
}

variable "network_blocks" {
  type        = list(number)
  description = "The third tuple of network blocks to use"
}
