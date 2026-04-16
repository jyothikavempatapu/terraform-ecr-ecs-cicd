resource "aws_ecr_repository" "main" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true   # Automatically scan images for vulnerabilities
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr"
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only the last 10 images — clean up old builds"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = { type = "expire" }
      }
    ]
  })
}
