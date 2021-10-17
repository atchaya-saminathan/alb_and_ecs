resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/zoominfo_task"
  tags = {
   Name = "zoominfo_ecs_log"
  }
}

