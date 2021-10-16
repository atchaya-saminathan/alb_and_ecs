resource "aws_wafv2_web_acl" "web_acl" {
  name = "zoominfo_web_acl"
  description = "zoominfo_web_acl"
  scope = "REGIONAL"
  default_action {
   allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "zoominfo_webacl"
    sampled_requests_enabled   = true 
  }
  tags = {
    Name = "zoominfo_web_acl"
  }
  rule {
    name     = "rate_based_rule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 500
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["IN"]
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "zoominfo_rate_based_rule"
      sampled_requests_enabled   = true
   }
  }
}

resource "aws_wafv2_web_acl_association" "webacl" {
  resource_arn = module.alb.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}
