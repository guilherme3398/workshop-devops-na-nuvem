locals {
  user-console-eks-arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/Devops"
  eks_oidc_url         = replace(aws_eks_cluster.dnn_eks_cluster.identity[0].oidc[0].issuer, "https://", "")
}