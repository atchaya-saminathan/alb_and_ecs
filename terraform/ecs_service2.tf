module "ecs_security_group2" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"
  name    = "ecs_task2"
  description = "SG for ECS tasks"
  vpc_id = module.vpc2.vpc_id
  ingress_cidr_blocks = ["10.0.0.0/16","10.3.0.0/16"]
  ingress_rules = ["http-80-tcp"]
  egress_rules = ["all-all"]
}

module "ecs_cluster_2" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.0"
  name = "zoominfo-cluster2"
  container_insights = "false"
  capacity_providers = ["FARGATE"]
  tags = {
    Name = "zoominfo-cluster2"
 } 
}

resource "aws_ecs_task_definition" "task_definition2" {
  family = "zooninfo_td2"

  container_definitions = <<EOF
[
  {
    "name": "zoominfo_task2",
    "image": "486526169498.dkr.ecr.us-west-2.amazonaws.com/atchaya:service",
    "cpu": 256,
    "memory": 256,
    "memoryReservation": 128,
    "essential": true,
    "portMappings": [ 
      {    
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-west-2",
        "awslogs-group": "/ecs/zoominfo_task2",
        "awslogs-stream-prefix": "apache"
      }
    }
  }
]
EOF
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn = data.aws_iam_role.ecs_role.arn
  task_role_arn = data.aws_iam_role.ecs_role.arn
  tags = {
   Name = "zoominfo_td2"
  }
}

resource "aws_ecs_service" "service2" {
  name            = "zoominfo_service2"
  cluster         = module.ecs_cluster_2.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_definition2.arn
  desired_count   = 1
#  iam_role        = data.aws_iam_role.ecs_role.arn
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100 
  launch_type = "FARGATE"
  platform_version = "LATEST"
  scheduling_strategy = "REPLICA"
  load_balancer {
    target_group_arn = element(module.private_alb.target_group_arns,0)
    container_name   = "zoominfo_task2"
    container_port   = 80
  }
  tags = {
    Name = "zoominfo_service2"
  }
  network_configuration {
    subnets = module.vpc2.private_subnets 
    security_groups = [module.ecs_security_group2.security_group_id]
    assign_public_ip = false
 }
}

resource "aws_appautoscaling_target" "autoscaling2" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${module.ecs_cluster_2.ecs_cluster_name}/${aws_ecs_service.service2.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "request2" {
  name               = "request-auto-scaling2"
  service_namespace  = aws_appautoscaling_target.autoscaling2.service_namespace
  scalable_dimension = aws_appautoscaling_target.autoscaling2.scalable_dimension
  resource_id        = aws_appautoscaling_target.autoscaling2.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${module.private_alb.lb_arn_suffix}/${module.private_alb.target_group_arn_suffixes[0]}"
    }

    target_value       = 75
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
