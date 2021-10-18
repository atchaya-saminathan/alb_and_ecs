resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = module.vpc2.vpc_id
  vpc_id        = module.vpc.vpc_id
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true
}


resource "aws_route" "service1" {
  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block  = "10.3.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "service2" {
  route_table_id            = module.vpc2.private_route_table_ids[0]
  destination_cidr_block  = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
