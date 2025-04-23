output "get_order_api_endpoint" {
  description = "Admin API to fetch orders"
  value       = aws_apigatewayv2_api.api.api_endpoint
}
