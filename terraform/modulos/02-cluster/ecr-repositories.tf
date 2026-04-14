resource "aws_ecr_repository" "dnn_ecr" {
  name                 = "dnn-conversao-distancia"
  image_tag_mutability = "MUTABLE"


}