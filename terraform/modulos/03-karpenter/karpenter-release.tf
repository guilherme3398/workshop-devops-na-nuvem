resource "helm_release" "karpenter_release" {
  name                = "karpenter" 
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = "1.5.0"
  namespace           = "kube-system"
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  values = [
    templatefile("${path.module}/helm/values.yaml", {
      NODEGROUP = local.eks_cluster_node_group_name
  })]

  wait            = false
  cleanup_on_fail = true
  timeout         = 300

  set = [
    {
      name  = "settings.clusterName"
      value = local.eks_cluster_name
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.dnn_karpenter_controller_role.arn
    },
    {
      name  = "controller.resources.requests.cpu"
      value = 1
    },
    {
      name  = "controller.resources.limits.cpu"
      value = 1
    },
    {
      name  = "controller.resources.requests.memory"
      value = "1Gi"
    },
    {
      name  = "controller.resources.limits.cpu"
      value = "1Gi"
    }

  ]

  depends_on = [
    terraform_data.karpenter_crds,
    aws_iam_role_policy_attachment.karpenter_controller_custom_policy
  ]

}