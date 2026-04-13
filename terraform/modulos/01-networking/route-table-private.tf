resource "aws_route_table" "eks_rtb_private" {
  count = length(aws_subnet.eks_subnet_private)

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_ngw[count.index].id
  }

  tags = {
    Name = var.vpc.route_table_private_name
  }
}

resource "aws_route_table_association" "eks_rtb_private_assoc" {
  count = length(var.vpc.subnets_private)

  subnet_id      = aws_subnet.eks_subnet_private[count.index].id
  route_table_id = aws_route_table.eks_rtb_private[count.index].id
}