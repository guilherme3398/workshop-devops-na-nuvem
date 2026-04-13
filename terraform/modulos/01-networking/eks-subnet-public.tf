resource "aws_subnet" "eks_subnet_public" {
  count = length(var.vpc.subnets_public)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.vpc.subnets_public[count.index].cidr_block
  availability_zone       = var.vpc.subnets_public[count.index].availability_zone
  map_public_ip_on_launch = var.vpc.subnets_public[count.index].map_public_ip_on_launch

  tags = {
    Name                     = var.vpc.subnets_public[count.index].name,
    "kubernetes.io/role/elb" = 1
  }
}

