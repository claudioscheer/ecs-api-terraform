resource "aws_cloudwatch_log_group" "ecs_api_terraform_task_log_group" {
  name = "/ecs/service/ecs-api-terraform-task"
}

