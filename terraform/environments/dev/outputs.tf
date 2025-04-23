output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3_static_site.bucket_name
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = module.s3_static_site.bucket_domain_name
}

output "website_endpoint" {
  description = "S3 static website endpoint"
  value       = module.s3_static_site.website_endpoint
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = aws_cloudfront_distribution.s3_distribution[0].domain_name
}

output "acm_certificate_arn" {
  value = aws_acm_certificate_validation.validated.certificate_arn
}

output "api_endpoint" {
  description = "Public API endpoint for checkout"
  value       = module.lambda_api.api_endpoint
}

output "checkout_api_endpoint" {
  description = "Public API endpoint for checkout route"
  value       = module.lambda_checkout.checkout_api_endpoint
}
output "get_order_api_endpoint" {
  description = "Public API endpoint for GET /orders/{order_id}"
  value       = module.lambda_get_order.get_order_api_endpoint
}
output "contact_api_endpoint" {
  value       = module.lambda_contact.contact_api_endpoint
  description = "JWT-protected POST /contact endpoint"
}
output "feedback_api_endpoint" {
  value       = module.lambda_feedback.feedback_api_endpoint
  description = "Public API for product feedback"
}
