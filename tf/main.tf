terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "ecs_api_terraform_repo" {
  name = "ecs-api-terraform-repo"
}

resource "aws_ecs_cluster" "ecs_api_terraform_cluster" {
  name = "ecs-api-terraform-cluster"
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
      "name": "ecs-api-terraform-container",
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
      }
    }
  ]
  DEFINITION
}
