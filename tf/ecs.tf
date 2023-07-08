resource "aws_ecr_repository" "ecs_api_terraform_repo" {
  name = "ecs-api-terraform-repo"
}

resource "aws_ecs_cluster" "ecs_api_terraform_cluster" {
  name = "ecs-api-terraform-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_api_terraform_task_log_group" {
  name = "/ecs/service/ecs-api-terraform-task"
}

resource "aws_ecs_task_definition" "ecs_api_terraform_task" {
  family                   = "ecs-api-terraform-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = <<DEFINITION
  [
    {
      "name": "ecs-api-terraform-task",
      "image": "${aws_ecr_repository.ecs_api_terraform_repo.repository_url}:latest",
      "essential": true,
      "memory": 512,
      "cpu": 256,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.ecs_api_terraform_task_log_group.name}",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "ecs_api_terraform_service" {
  name            = "ecs-api-terraform-service"
  cluster         = aws_ecs_cluster.ecs_api_terraform_cluster.id
  task_definition = aws_ecs_task_definition.ecs_api_terraform_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]
    security_groups  = [aws_security_group.service_security_group.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_api_lb_target_group.arn
    container_name   = aws_ecs_task_definition.ecs_api_terraform_task.family
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.ecs_api_lb_listener]
}
