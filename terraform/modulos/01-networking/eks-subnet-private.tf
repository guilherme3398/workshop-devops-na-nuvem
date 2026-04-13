resource "aws_subnet" "eks_subnet_private" {
  count = length(var.vpc.subnets_private)

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.vpc.subnets_private[count.index].cidr_block
  availability_zone       = var.vpc.subnets_private[count.index].availability_zone
  map_public_ip_on_launch = var.vpc.subnets_private[count.index].map_public_ip_on_launch

  tags = {
    Name                              = var.vpc.subnets_private[count.index].name,
    "kubernetes.io/role/internal-elb" = 1,
    "karpenter.sh/discovery" = var.vpc.eks_cluster_name_tag,
  }
}

