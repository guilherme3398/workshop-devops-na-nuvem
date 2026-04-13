resource "aws_iam_role" "dnn_eks_node_group_iam_role" {
  name = var.eks_cluster.eks_node_group.role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
      } },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dnn_eks_node_group_iam_role_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.dnn_eks_node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "dnn_eks_node_group_iam_role_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.dnn_eks_node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "dnn_eks_node_group_iam_role_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.dnn_eks_node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "dnn_eks_node_group_iam_role_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.dnn_eks_node_group_iam_role.name
}