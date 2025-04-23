resource "aws_iam_role" "lambda_exec" {
  name = "lambda_feedback_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "ses_send" {
  name = "lambda-feedback-ses"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [ "ses:SendEmail", "ses:SendRawEmail" ],
      Effect = "Allow",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "feedback_ses_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.ses_send.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "feedback" {
  function_name = "feedback-lambda"
  handler       = "feedback.lambda_handler"
  runtime       = "python3.11"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      JWT_SECRET    = "onepass_super_secret_key"
      SUPPORT_EMAIL = "support@onepassapparel.com"
    }
  }
}

resource "aws_apigatewayv2_api" "api" {
  name          = "feedback-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id                  = aws_apigatewayv2_api.api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.feedback.invoke_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /feedback"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_api" {
  statement_id  = "AllowFeedbackExecution"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.feedback.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
