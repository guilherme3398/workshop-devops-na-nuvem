resource "aws_iam_role" "dnn_karpenter_controller_role" {
  name = var.karpenter.controller_role_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = local.eks_oidc_arn #pegando arn do OIDC
      }
      Condition : {
        StringEquals : {
          "${local.eks_oidc_url}:aud" = "sts.amazonaws.com"
          "${local.eks_oidc_url}:sub" = "system:serviceaccount:kube-system:karpenter"
      } }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name        = var.karpenter.controller_policy_name
  description = "IAM policy para o controller do Karpenter gerenciar instâncias EC2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "KarpenterPermissions"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts"
        ]
        Resource = "*"
      },
      {
        Sid      = "ConditionalEC2Termination"
        Effect   = "Allow"
        Action   = "ec2:TerminateInstances"
        Resource = "*"
        Condition = {
          StringLike = {
            "ec2:ResourceTag/karpenter.sh/nodepool" = "*"
          }
        }
      },
      {
        Sid    = "PassNodeIAMRole"
        Effect = "Allow"
        Action = "iam:PassRole"
        # Aqui garantimos que o Karpenter só possa passar a Role específica dos nós que ele cria
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.karpenter_node_role_name}"
      },
      {
        Sid      = "EKSClusterEndpointLookup"
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${local.eks_cluster_name}"
      },
      {
        Sid    = "AllowScopedInstanceProfileCreationActions"
        Effect = "Allow"
        Action = [
          "iam:CreateInstanceProfile"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                                 = "${var.region}"
          }
          StringLike = {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid    = "AllowScopedInstanceProfileTagActions"
        Effect = "Allow"
        Action = [
          "iam:TagInstanceProfile"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                                 = "${var.region}"
            "aws:RequestTag/kubernetes.io/cluster/${local.eks_cluster_name}"  = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                                  = "${var.region}"
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
          }
        }
      },
      {
        Sid    = "AllowScopedInstanceProfileActions"
        Effect = "Allow"
        Action = [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                                 = "${var.region}"
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowInstanceProfileReadActions"
        Effect   = "Allow"
        Action   = "iam:GetInstanceProfile"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_custom_policy" {
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
  role       = aws_iam_role.dnn_karpenter_controller_role.name
}


