resource "aws_iam_role" "github_iam_role" {
  name = "dnn-github-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Action = [
        "sts:AssumeRoleWithWebIdentity",
        "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:guilherme3398/workshop-devops-na-nuvem:*"
          }
        },
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }

    ]
  })
}


resource "aws_iam_policy" "github_iam_policy" {
  name        = "dnn-github-policy"
  description = "IAM Policy para Github"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Sid = "GetAuthorizationToken",
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"        
      },
        {
        Effect = "Allow"
        Sid= "AllowPushPull",
        Action = [
           "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:CompleteLayerUpload",
            "ecr:GetDownloadUrlForLayer",
            "ecr:InitiateLayerUpload",
            "ecr:PutImage",
            "ecr:UploadLayerPart"
        ]
        Resource = aws_ecr_repository.this[*].arn  #CRIAR RECURSO       
      },     
    ]
  })
}


resource "aws_iam_role_policy_attachment" "dnn_github_role_attach" {
  policy_arn = aws_iam_policy.github_iam_policy.arn
  role       = aws_iam_role.github_iam_role.name 
}
