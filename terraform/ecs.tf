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
