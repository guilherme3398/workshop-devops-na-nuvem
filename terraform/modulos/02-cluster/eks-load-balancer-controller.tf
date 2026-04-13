resource "helm_release" "load_balancer_controller_helm" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.14.0"
  namespace  = "kube-system"

  cleanup_on_fail = true

  set = [
    {
      name  = "clusterName"
      value = aws_eks_cluster.dnn_eks_cluster.id
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.dnn_load_balancer_controller_iam.arn
    },
    {
      name  = "serviceAccount.create"
      value = true
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = data.aws_vpc.data_vpc.id
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }

  ]

  depends_on = [
    aws_iam_policy.policy_load_balancer_controller
  ]
}

