resource "aws_route53_zone" "onepass" {
  name = "onepassapparel.com"
}

output "route53_name_servers" {
  description = "NS records for Route 53 to update at domain registrar"
  value       = aws_route53_zone.onepass.name_servers
}
resource "aws_route53_record" "root_alias" {
  zone_id = aws_route53_zone.onepass.zone_id
  name    = "onepassapparel.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution[0].domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.onepass.zone_id
  name    = "www.onepassapparel.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.s3_distribution[0].domain_name]
}
