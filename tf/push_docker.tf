resource "null_resource" "push_docker_image" {
  depends_on = [aws_ecr_repository.ecs_api_terraform_repo]

  provisioner "local-exec" {
    command = "docker build -t ecs-api-terraform-repo ../"
  }

  provisioner "local-exec" {
    command = "docker tag ecs-api-terraform-repo:latest ${aws_ecr_repository.ecs_api_terraform_repo.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecs_api_terraform_repo.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ecs_api_terraform_repo.repository_url}:latest"
  }

  triggers = {
    build_number = timestamp()
  }
}
