output "kubernetes_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.kubernetes.arn
}

output "kubernetes_oidc_provider_url" {
  value = aws_eks_cluster.dnn_eks_cluster.identity[0].oidc[0].issuer
}

output "eks_cluster_name" {
  value = aws_eks_cluster.dnn_eks_cluster.name
}

output "eks_cluster_security_group" {
  value = aws_eks_cluster.dnn_eks_cluster.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.dnn_eks_cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.dnn_eks_cluster.certificate_authority[0].data
}

output "eks_cluster_node_group_name" {
  value = aws_eks_node_group.dnn_eks_node_group.node_group_name
}

output "karpenter_node_role_name" {
  value = aws_iam_role.dnn_eks_node_group_iam_role.name
}