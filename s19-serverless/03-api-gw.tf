resource "aws_api_gateway_rest_api" "demo" {
  name = "MyFirstAPI"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "get_root" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_rest_api.demo.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.demo.id
}

resource "aws_api_gateway_integration" "get_root_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo.id
  http_method             = aws_api_gateway_method.get_root.http_method
  resource_id             = aws_api_gateway_rest_api.demo.root_resource_id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "houses" {
  parent_id   = aws_api_gateway_rest_api.demo.root_resource_id
  path_part   = "houses"
  rest_api_id = aws_api_gateway_rest_api.demo.id
}

resource "aws_api_gateway_method" "get_houses" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.houses.id
  rest_api_id   = aws_api_gateway_rest_api.demo.id
}

resource "aws_api_gateway_integration" "get_houses_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo.id
  http_method             = aws_api_gateway_method.get_houses.http_method
  resource_id             = aws_api_gateway_resource.houses.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda_houses.invoke_arn
}

resource "aws_api_gateway_deployment" "demo" {
  rest_api_id = aws_api_gateway_rest_api.demo.id

  depends_on = [
    aws_api_gateway_method.get_root,
    aws_api_gateway_integration.get_root_lambda_integration,
    aws_api_gateway_method.get_houses,
    aws_api_gateway_integration.get_houses_lambda_integration
  ]
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.demo.id
  rest_api_id   = aws_api_gateway_rest_api.demo.id
  stage_name    = "dev"
}

resource "aws_lambda_function" "api_lambda" {
  function_name = "api-gateway-root-get"
  # I reused the same role as the lambda function
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_code_zip.output_path
  handler       = "lambda-code.lambda_handler"
  runtime       = "python3.13"
  architectures = ["x86_64"]

  source_code_hash = data.archive_file.lambda_code_zip.output_base64sha256
}

data "archive_file" "lambda_code_zip" {
  type        = "zip"
  source_file = "../resources/lambda-code.py"
  output_path = "lambda_code.zip"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.demo.id}/*/${aws_api_gateway_method.get_root.http_method}/"
}

resource "aws_lambda_function" "api_lambda_houses" {
  function_name = "api-gateway-houses-get"
  # I reused the same role as the lambda function
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_code_houses_zip.output_path
  handler       = "lambda-code-houses.lambda_handler"
  runtime       = "python3.13"
  architectures = ["x86_64"]

  source_code_hash = data.archive_file.lambda_code_houses_zip.output_base64sha256
}

data "archive_file" "lambda_code_houses_zip" {
  type        = "zip"
  source_file = "../resources/lambda-code-houses.py"
  output_path = "lambda_code_houses.zip"
}

resource "aws_lambda_permission" "apigw_lambda_houses" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda_houses.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.demo.id}/*/${aws_api_gateway_method.get_houses.http_method}/houses"
}

output "api_invoke_url" {
  value = aws_api_gateway_stage.dev.invoke_url
}