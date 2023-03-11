resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.supabase.bucket_name
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster" # Name your cluster here
}

resource "aws_ecs_task_definition" "supabase-dc" {
  family                = "supabase-dc" # Naming our first task
  container_definitions = jsonencode(local.supabase-dc-ecs-config)
  volume {
    name      = local.docker_sock_volume_name
    host_path = "/var/run/docker.sock"
  }
}

resource "aws_ecs_service" "run-task" {
  name            = "run-task"
  task_definition = aws_ecs_task_definition.supabase-dc.arn
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
}

resource "local_file" "supabase-nextjs-env" {
  content = <<HEREDOC
NEXT_PUBLIC_SUPABASE_URL=http://localhost
NEXT_PUBLIC_SUPABASE_ANON_KEY=${jwt_hashed_token.anon.token}
DB_URL=postgres://postgres:${random_password.psql.result}@localhost:5432
  HEREDOC
  filename = "${path.module}/../supabase-nextjs/.env.local"
}
