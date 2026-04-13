resource "aws_eks_access_entry" "access_eks_cluster" {
  cluster_name  = aws_eks_cluster.dnn_eks_cluster.name
  principal_arn = local.user-console-eks-arn
  type          = "STANDARD"
}


resource "aws_eks_access_policy_association" "user_console_assoc" {
  cluster_name  = aws_eks_cluster.dnn_eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.user-console-eks-arn

  access_scope {
    type = "cluster"
  }
}