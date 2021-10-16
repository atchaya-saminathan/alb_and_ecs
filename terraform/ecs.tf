module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.0"
  name = "zoominfo-cluster"
  container_insights = "false"
  capacity_providers = ["FARGATE"]
#  default_capacity_provider_strategy = { 
#    capacity_provider = "FARGATE"
#  }
  tags = {
    Name = "zoominfo-cluster"
 } 
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "zooninfo_td"

  container_definitions = <<EOF
[
  {
    "name": "test",
    "image": "486526169498.dkr.ecr.us-west-2.amazonaws.com/atchaya:latest",
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
        "awslogs-group": "/ecs/zoominfo",
        "awslogs-stream-prefix": "ecs"
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

