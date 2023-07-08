terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-ecs-api-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-ecs-api-terraform-dev"
  }
}

provider "aws" {
  region = "us-east-1"
}

output "ecs_api_lb_dns_name" {
  value = aws_lb.ecs_api_lb.dns_name
}
