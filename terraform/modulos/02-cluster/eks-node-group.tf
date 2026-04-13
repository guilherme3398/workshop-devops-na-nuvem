resource "aws_eks_node_group" "dnn_eks_node_group" {
  cluster_name    = aws_eks_cluster.dnn_eks_cluster.name
  node_group_name = var.eks_cluster.eks_node_group.name
  node_role_arn   = aws_iam_role.dnn_eks_node_group_iam_role.arn
  subnet_ids      = data.aws_subnets.private.ids
  instance_types  = var.eks_cluster.eks_node_group.instance_types
  capacity_type   = var.eks_cluster.eks_node_group.capacity_type

  scaling_config {
    desired_size = var.eks_cluster.eks_node_group.scaling_config.desired_size
    max_size     = var.eks_cluster.eks_node_group.scaling_config.max_size
    min_size     = var.eks_cluster.eks_node_group.scaling_config.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.dnn_eks_node_group_iam_role_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.dnn_eks_node_group_iam_role_AmazonEC2ContainerRegistryPullOnly,
    aws_iam_role_policy_attachment.dnn_eks_node_group_iam_role_AmazonEKS_CNI_Policy,
  ]
}