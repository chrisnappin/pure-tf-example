module "frontend_subnets" {
  source             = "../../modules/subnets"
  name               = "frontend"
  vpc_id             = aws_vpc.main.id
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  network_blocks     = var.frontend_network_blocks
}