resource "aws_s3_bucket" "bucket_eks_dnn" {
  bucket = var.remote_backend.bucket
}

resource "aws_s3_bucket_versioning" "versioning_bucket_eks_dnn" {
  bucket = aws_s3_bucket.bucket_eks_dnn.id
  versioning_configuration {
    status = "Enabled"
  }
}