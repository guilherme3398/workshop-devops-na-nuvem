resource "aws_route_table" "eks_rtb_pub" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = var.vpc.route_table_pub_name
  }
}

resource "aws_route_table_association" "eks_rtb_pub_assoc" {
  count = length(var.vpc.subnets_public)

  subnet_id      = aws_subnet.eks_subnet_public[count.index].id
  route_table_id = aws_route_table.eks_rtb_pub.id
}