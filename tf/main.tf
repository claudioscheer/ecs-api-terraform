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
