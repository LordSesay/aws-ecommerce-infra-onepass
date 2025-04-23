resource "aws_acm_certificate" "onepass" {
  domain_name               = "onepassapparel.com"
  validation_method         = "DNS"
  subject_alternative_names = ["www.onepassapparel.com"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project     = "OnePass-Ecommerce"
    Environment = var.environment
    Managed_By  = "Terraform"
  }
}

resource "aws_route53_record" "acm_validation" {
  count = length(tolist(aws_acm_certificate.onepass.domain_validation_options))

  name    = tolist(aws_acm_certificate.onepass.domain_validation_options)[count.index].resource_record_name
  type    = tolist(aws_acm_certificate.onepass.domain_validation_options)[count.index].resource_record_type
  zone_id = aws_route53_zone.onepass.zone_id
  records = [tolist(aws_acm_certificate.onepass.domain_validation_options)[count.index].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "validated" {
  certificate_arn         = aws_acm_certificate.onepass.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}
