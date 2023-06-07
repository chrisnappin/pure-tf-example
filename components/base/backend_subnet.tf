module "backend_subnets" {
  source             = "../../modules/subnets"
  name               = "backend"
  vpc_id             = aws_vpc.main.id
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  network_blocks     = var.backend_network_blocks
}
