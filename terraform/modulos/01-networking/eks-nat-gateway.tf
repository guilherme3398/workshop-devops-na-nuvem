resource "aws_nat_gateway" "eks_ngw" {
  count = length(var.vpc.subnets_public)

  allocation_id = aws_eip.eks_ngw_eip[count.index].id
  subnet_id     = aws_subnet.eks_subnet_public[count.index].id

  tags = {
    Name = "${var.vpc.nat_gateway_name}-${aws_subnet.eks_subnet_public[count.index].availability_zone}"
  }


  depends_on = [aws_internet_gateway.eks_igw]
}