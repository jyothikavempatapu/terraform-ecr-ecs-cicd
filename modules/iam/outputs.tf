output "ecs_task_execution_role_arn" { value = aws_iam_role.ecs_task_execution.arn }
output "ecs_task_role_arn"           { value = aws_iam_role.ecs_task.arn }
output "ci_user_access_key_id"       { value = aws_iam_access_key.ci.id }
output "ci_user_secret_key"          { value = aws_iam_access_key.ci.secret  sensitive = true }
