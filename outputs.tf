output "ecr_repository_url" {
  description = "Full ECR repository URL — use this in GitHub Actions"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "ECR repository name"
  value       = var.ecr_repo_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "ci_user_access_key_id" {
  description = "Access key ID for the CI/CD IAM user — add to GitHub Secrets as AWS_ACCESS_KEY_ID"
  value       = module.iam.ci_user_access_key_id
  sensitive   = false
}

output "ci_user_secret_key" {
  description = "Secret access key for the CI/CD IAM user — add to GitHub Secrets as AWS_SECRET_ACCESS_KEY"
  value       = module.iam.ci_user_secret_key
  sensitive   = true
}

output "app_url" {
  description = "Public URL of the running ECS service"
  value       = module.ecs.app_url
}

output "docker_push_commands" {
  description = "Commands to manually push a Docker image to ECR"
  value       = <<-EOT
    aws ecr get-login-password --region ${var.aws_region} | \
      docker login --username AWS --password-stdin ${module.ecr.repository_url}
    docker build -t ${var.ecr_repo_name} ./app
    docker tag ${var.ecr_repo_name}:latest ${module.ecr.repository_url}:latest
    docker push ${module.ecr.repository_url}:latest
  EOT
}
