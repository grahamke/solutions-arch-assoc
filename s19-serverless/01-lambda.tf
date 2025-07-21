resource "aws_lambda_function" "demo" {
  function_name = "HelloWorld"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "lambda_function.lambda_handler"
  architectures = ["x86_64"]

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # reserved_concurrent_executions = 20
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../resources/lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  name               = "lambda_role_demo_HelloWorld"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "basic_lambda" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}