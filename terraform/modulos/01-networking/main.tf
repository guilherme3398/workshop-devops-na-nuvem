terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "dnn-terraform-state-file"
    key            = "dnn-cluster-eks/terraform.tfstate"
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