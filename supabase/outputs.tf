output "task_definition_arn" {
  value     = aws_ecs_task_definition.supabase-dc.arn
}

output "ANON_KEY" {
  value = jwt_hashed_token.anon.token
  sensitive = true
}

output "SERVICE_ROLE_KEY" {
  value = jwt_hashed_token.service_role.token
  sensitive = true
}

output "POSTGRES_PASSWORD" {
  value = random_password.psql.result
  sensitive = true
}
