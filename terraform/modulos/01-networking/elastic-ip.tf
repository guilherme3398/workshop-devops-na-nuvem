resource "aws_eip" "eks_ngw_eip" {
  count = length(aws_subnet.eks_subnet_public) # são 2 nats 1 para cada subnet privada

  domain = "vpc"

  tags = {
    Name                     = var.vpc.elastic_ip_name
  }
}

