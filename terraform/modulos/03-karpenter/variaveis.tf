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

variable "karpenter" {
  type = object({
    controller_role_name   = string
    controller_policy_name = string
  })

  default = {
    controller_role_name   = "KarpenterControllerRole"
    controller_policy_name = "KarpenterControllerPolicy"
  }
}