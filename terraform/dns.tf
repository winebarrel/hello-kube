data "aws_route53_zone" "winebarrel_work" {
  name = "winebarrel.work."
}

resource "aws_acm_certificate" "cert" {
  domain_name               = data.aws_route53_zone.winebarrel_work.name
  subject_alternative_names = ["*.${data.aws_route53_zone.winebarrel_work.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.winebarrel_work.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
