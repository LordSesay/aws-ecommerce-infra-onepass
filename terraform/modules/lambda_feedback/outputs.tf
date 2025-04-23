output "feedback_api_endpoint" {
  value       = aws_apigatewayv2_api.api.api_endpoint
  description = "JWT-protected POST /feedback endpoint"
}
