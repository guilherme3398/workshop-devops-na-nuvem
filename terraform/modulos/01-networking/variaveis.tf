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

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    route_table_pub_name     = string
    route_table_private_name = string
    elastic_ip_name          = string
    eks_cluster_name_tag = string

    subnets_public = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))

    subnets_private = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))

  })

  default = {
    name                     = "dnn-eks-vpc"
    cidr_block               = "10.0.0.0/16"
    internet_gateway_name    = "dnn-eks-igw"
    nat_gateway_name         = "dnn-eks-ngw"
    route_table_pub_name     = "dnn-eks-rtb-public"
    route_table_private_name = "dnn-eks-rtb-private"
    elastic_ip_name          = "dnn-eks-eip"
    eks_cluster_name_tag = "dnn-eks-cluster"

    subnets_public = [{
      name                    = "dnn-subnet-public-us-east-1a"
      cidr_block              = "10.0.0.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "dnn-subnet-public-us-east-1b"
        cidr_block              = "10.0.1.0/24"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
      }

    ]

    subnets_private = [{
      name                    = "dnn-subnet-private-us-east-1a"
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "dnn-subnet-private-us-east-1b"
        cidr_block              = "10.0.3.0/24"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
      }

    ]
  }
}