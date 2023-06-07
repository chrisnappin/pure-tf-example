# creates several subnets, one for each availability zone
# each is an 8 bit block, with the third tuple set by the network blocks input
resource "aws_subnet" "subnet" {
  count = length(var.availability_zones)

  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.cidr_block, 8, var.network_blocks[count.index])
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name}${count.index}"
  }
}
