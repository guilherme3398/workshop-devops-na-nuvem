variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "Workshop-devops-na-nuvem"
    Environment = "Production"
  }
}

variable "eks_cluster" {
  type = object({
    name      = string
    role_name = string
    version   = string
    access_config = object({
      authentication_mode = string
    })

    eks_node_group = object({
      name           = string
      role_name      = string
      instance_types = list(string)
      capacity_type  = string
      scaling_config = object({
        desired_size = number
        max_size     = number
        min_size     = number
      })

    })

  })

  default = {
    name      = "dnn-eks-cluster"
    role_name = "dnn-eks-cluster-iam-role"
    version   = "1.32"
    access_config = {
      authentication_mode = "API_AND_CONFIG_MAP"
    }

    eks_node_group = {
      name           = "dnn-eks-node-group"
      role_name      = "dnn-eks-node-group-iam-role"
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 1
        max_size     = 2
        min_size     = 1
      }
    }
  }
}