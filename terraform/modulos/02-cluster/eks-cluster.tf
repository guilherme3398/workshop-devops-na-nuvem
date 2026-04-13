resource "aws_eks_cluster" "dnn_eks_cluster" {
  name     = var.eks_cluster.name
  role_arn = aws_iam_role.dnn_eks_cluster_iam_role.arn
  version  = var.eks_cluster.version

  access_config {
    authentication_mode = var.eks_cluster.access_config.authentication_mode
  }

  vpc_config {
    subnet_ids = data.aws_subnets.private.ids
  }


  depends_on = [
    aws_iam_role_policy_attachment.dnn_eks_cluster_iam_role_AmazonEKSClusterPolicy,
  ]
}

