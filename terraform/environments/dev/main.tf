provider "aws" {
  region                  = "us-east-1"
  access_key              = var.aws_access_key
  secret_key              = var.aws_secret_key

  default_tags {
    tags = {
      Project     = "OnePass-Ecommerce"
      Managed_By  = "Terraform"
      Environment = var.environment
    }
  }
}

locals {
  s3_origin_id = "S3-${module.s3_static_site.bucket_domain_name}"
}

module "s3_static_site" {
  source = "../../modules/s3_static_site"

  bucket_name = format("onepass-static-site-%s-%s", var.environment, random_id.suffix.hex)
  environment = var.environment
  
  allowed_ips = var.environment == "prod" ? var.allowed_production_ips : ["0.0.0.0/0"]

  enable_versioning = true
  enable_encryption = true
  
  tags = merge(
    var.additional_tags,
    {
      Component = "Static Website"
      Service   = "Frontend"
    }
  )
}

# Generate a random suffix for globally unique bucket names
resource "random_id" "suffix" {
  byte_length = 4
}

# CloudFront distribution for better performance and security
resource "aws_cloudfront_distribution" "s3_distribution" {
  count = var.enable_cdn ? 1 : 0

  aliases = ["onepassapparel.com", "www.onepassapparel.com"]

  origin {
    domain_name = module.s3_static_site.website_endpoint
    origin_id   = local.s3_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
  acm_certificate_arn            = aws_acm_certificate_validation.validated.certificate_arn
  ssl_support_method             = "sni-only"
  minimum_protocol_version       = "TLSv1.2_2021"
}

  tags = {
    Component = "CDN"
  }
}

# WAF Web ACL for additional security
resource "aws_wafv2_web_acl" "main" {
  count       = var.enable_waf ? 1 : 0
  name        = "static-site-protection"
  description = "Basic WAF with rate limiting for CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "LimitRequestsByIP"
    priority = 1

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "LimitRequestsByIP"
    }

    override_action {
      none {}
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "StaticSiteWAF"
  }

  tags = {
    Project     = "OnePass-Ecommerce"
    Environment = var.environment
    Managed_By  = "Terraform"
  }
}