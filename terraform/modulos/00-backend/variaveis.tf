variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "Devops-na-nuvem"
    Environment = "Production"
  }
}

variable "remote_backend" {
  type = object({
    bucket = string
    state_locking = object({
      dynamodb_name          = string
      dynamodb_billing_mode  = string
      dynamodb_hash_key      = string
      dynamodb_hash_key_type = string

    })
  })

  default = {
    bucket = "dnn-terraform-state-file"
    state_locking = {
      dynamodb_name          = "dnn-eks-state-locking"
      dynamodb_billing_mode  = "PAY_PER_REQUEST"
      dynamodb_hash_key      = "LockID"
      dynamodb_hash_key_type = "S"
    }
  }
}