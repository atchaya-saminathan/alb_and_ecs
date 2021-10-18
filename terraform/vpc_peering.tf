resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = module.vpc2.vpc_id
  vpc_id        = module.vpc.vpc_id
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true
}


