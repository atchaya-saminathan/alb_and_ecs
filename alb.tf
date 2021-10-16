module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"
  name    = "alb"
  description = "SG for ALB"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["http-80-tcp"]
  egress_rules = ["all-all"]
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "6.0.0"
  name = "Zoominfo-alb"
  load_balancer_type = "application"
  internal = "false"
  vpc_id          = module.vpc.vpc_id
  security_groups = [module.security-group.security_group_id]
  subnets         = module.vpc.public_subnets
  tags = {
    Name = "alb"
   }
  target_groups = [
    {
      name          = "alb-target-group"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 20
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
   ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }
  ]
}

