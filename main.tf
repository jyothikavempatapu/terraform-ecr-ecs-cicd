module "iam" {
  source = "./modules/iam"

  project_name   = var.project_name
  environment    = var.environment
  aws_account_id = var.aws_account_id
  ecr_repo_name  = var.ecr_repo_name
}

module "ecr" {
  source = "./modules/ecr"

  project_name  = var.project_name
  environment   = var.environment
  ecr_repo_name = var.ecr_repo_name
}

module "ecs" {
  source = "./modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  aws_account_id     = var.aws_account_id
  ecr_repo_url       = module.ecr.repository_url
  ecr_repo_name      = var.ecr_repo_name
  task_execution_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  container_port     = var.container_port
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  desired_count      = var.desired_count
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}
