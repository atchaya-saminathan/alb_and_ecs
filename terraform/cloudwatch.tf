resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/zoominfo_task"
  tags = {
   Name = "zoominfo_ecs_log"
  }
}

resource "aws_cloudwatch_log_group" "log_group2" {
  name = "/ecs/zoominfo_task2"
  tags = {
   Name = "zoominfo_ecs_service_log"
  }
}

