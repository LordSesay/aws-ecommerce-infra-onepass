output "bucket_name" {
  description = "The name of the S3 bucket created for the static site"
  value       = aws_s3_bucket.site.id
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.site.bucket_domain_name
}

output "website_endpoint" {
  description = "The website endpoint URL for the static site"
  value       = aws_s3_bucket_website_configuration.site.website_endpoint
}
