module "ecs_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"
  name    = "ecs_task"
  description = "SG for ECS tasks"
  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["10.0.101.0/24","10.0.102.0/24"]
  ingress_rules = ["http-80-tcp","all-icmp"]
  egress_rules = ["all-all"]
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.0"
  name = "zoominfo-cluster"
  container_insights = "false"
  capacity_providers = ["FARGATE"]
  tags = {
    Name = "zoominfo-cluster"
 } 
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "zooninfo_td"

  container_definitions = <<EOF
[
  {
    "name": "zoominfo_task",
    "image": "486526169498.dkr.ecr.us-west-2.amazonaws.com/atchaya:python",
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
        "awslogs-group": "/ecs/zoominfo_task",
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
   Name = "zoominfo_td"
  }
}

resource "aws_ecs_service" "service" {
  name            = "zoominfo_service"
  cluster         = module.ecs.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
#  iam_role        = data.aws_iam_role.ecs_role.arn
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100 
  launch_type = "FARGATE"
  platform_version = "LATEST"
  scheduling_strategy = "REPLICA"
  load_balancer {
    target_group_arn = element(module.alb.target_group_arns,0)
    container_name   = "zoominfo_task"
    container_port   = 80
  }
  tags = {
    Name = "zoominfo_service"
  }
  network_configuration {
    subnets = module.vpc.private_subnets 
    security_groups = [module.ecs_security_group.security_group_id]
    assign_public_ip = false
 }
}


