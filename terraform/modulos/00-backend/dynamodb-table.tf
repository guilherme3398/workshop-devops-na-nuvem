resource "aws_dynamodb_table" "dnn_locking_bucket" {
  name         = var.remote_backend.state_locking.dynamodb_name
  billing_mode = var.remote_backend.state_locking.dynamodb_billing_mode
  hash_key     = var.remote_backend.state_locking.dynamodb_hash_key



attribute {
    name =  var.remote_backend.state_locking.dynamodb_hash_key
    type = var.remote_backend.state_locking.dynamodb_hash_key_type
  }
}