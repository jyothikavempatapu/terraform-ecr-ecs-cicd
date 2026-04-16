terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"   # CHANGE THIS
    key            = "project2-ecr-ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
