terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "dnn-terraform-state-file"
    key            = "dnn-eks-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dnn-eks-state-locking"
  }
}


provider "aws" {
  region = var.region
  default_tags { #incluindos as tags em todo o projeto
    tags = var.tags
  }
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.dnn_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.dnn_eks_cluster.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.dnn_eks_cluster.id]
      command     = "aws"
    }
  }
}