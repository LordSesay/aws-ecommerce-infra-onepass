environment = "dev"

allowed_production_ips = [
  "0.0.0.0/0" # Replace with actual IPs in prod
]

additional_tags = {
  Owner = "Malcolm"
  Department = "Engineering"
}

enable_cdn = true
enable_waf = false

aws_access_key = "env:AWS_ACCESS_KEY_ID"
aws_secret_key = "env:AWS_SECRET_ACCESS_KEY"
