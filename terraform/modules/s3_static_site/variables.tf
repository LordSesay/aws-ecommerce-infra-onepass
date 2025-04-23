variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Managed_By = "Terraform"
    Project    = "OnePass-Ecommerce"
  }

  validation {
    condition     = length(var.tags) > 0
    error_message = "At least one tag must be specified."
  }
}

variable "allowed_ips" {
  description = "List of allowed IP addresses/CIDR blocks that can access the website"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition = alltrue([
      for ip in var.allowed_ips : can(cidrhost(ip, 0))
    ])
    error_message = "All elements must be valid CIDR blocks."
  }
}

variable "bucket_name" {
  description = "Name of the S3 bucket for static website hosting"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be 3-63 characters long, contain only lowercase letters, numbers, dots, and hyphens, and start/end with a letter or number."
  }
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}

variable "error_document" {
  description = "Name of the error document for the static website"
  type        = string
  default     = "error.html"
}

variable "index_document" {
  description = "Name of the index document for the static website"
  type        = string
  default     = "index.html"
}
