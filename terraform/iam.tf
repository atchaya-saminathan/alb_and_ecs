/*
resource "aws_iam_role" "ecs_role" {
  name = "ecs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecc-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ecs-role"
  }
}
*/

data "aws_iam_role" "ecs_role" {
  name = "Oregon-ECSTaskExecutionRole"
}
