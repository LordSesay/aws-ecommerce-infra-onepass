variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "allowed_production_ips" {
  description = "Allowed IP addresses for production"
  type        = list(string)
  default     = []
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_cdn" {
  description = "Enable CloudFront CDN"
  type        = bool
  default     = false
}

variable "enable_waf" {
  description = "Enable WAF protection"
  type        = bool
  default     = false
}
variable "aws_access_key" {
  description = "AWS access key for CI/CD pipelines"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for CI/CD pipelines"
  type        = string
  sensitive   = true
}
