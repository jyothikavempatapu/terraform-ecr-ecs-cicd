variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "jyothika-app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_account_id" {
  description = "Your AWS account ID (12-digit number)"
  type        = string
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "jyothika-app"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "CPU units for ECS Fargate task (256 = 0.25 vCPU)"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory (MB) for ECS Fargate task"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of ECS task replicas to run"
  type        = number
  default     = 1
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}
