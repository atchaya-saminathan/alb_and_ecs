data "aws_acm_certificate" "issued" {
  domain   = "*.devhiring.insent.ai"
  statuses = ["ISSUED"]
}
