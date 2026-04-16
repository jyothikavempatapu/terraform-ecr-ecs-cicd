output "cluster_name"  { value = aws_ecs_cluster.main.name }
output "service_name"  { value = aws_ecs_service.app.name }
output "app_url"       { value = "http://<public-ip>:${var.container_port} (check ECS task for public IP)" }
