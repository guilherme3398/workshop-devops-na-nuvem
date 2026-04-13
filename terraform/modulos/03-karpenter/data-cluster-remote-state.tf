data "terraform_remote_state" "cluster_stack" {
  backend = "s3"

  config = {
    bucket         = "dnn-terraform-state-file"
    key            = "dnn-eks-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dnn-eks-state-locking"
  }
}