resource "aws_dynamodb_table" "demo" {
  name           = "DemoTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "stephane" {
  hash_key   = "user_id"
  table_name = aws_dynamodb_table.demo.name
  item       = <<ITEM
{
  "user_id": {"S": "stephane_123"},
  "name": {"S": "Stephane Maarek"},
  "favorite_movie": {"S": "Momento"},
  "favorite_number": {"N": "42"}
}
ITEM
}

resource "aws_dynamodb_table_item" "alice" {
  hash_key   = "user_id"
  table_name = aws_dynamodb_table.demo.name
  item       = <<ITEM
{
  "user_id": {"S": "alice_456"},
  "name": {"S": "Alice Doe"},
  "favorite_movie": {"S": "Pocahontas"},
  "age": {"N": "23"}
}
ITEM
}