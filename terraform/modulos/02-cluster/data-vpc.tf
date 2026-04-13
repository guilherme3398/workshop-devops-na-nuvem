data "aws_vpc" "data_vpc" {
  filter {
    name   = "tag:Name"
    values = ["dnn-eks-vpc"]
  }
}