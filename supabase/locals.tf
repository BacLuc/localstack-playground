resource "random_password" "psql" {
  length           = 32
  special          = true
  override_special = "-_"
  keepers = {
    seed = var.password_seed
  }
}

resource "random_password" "htpasswd" {
  length           = 32
  special          = true
  override_special = "-_"

  keepers = {
    seed = var.password_seed
  }
}

resource "htpasswd_password" "hash" {
  password = random_password.htpasswd.result

  lifecycle {
    ignore_changes = [password]
  }
}

resource "time_static" "jwt_iat" {}

resource "time_static" "jwt_exp" {
  rfc3339 = timeadd(time_static.jwt_iat.rfc3339, "43829h") # Add 5 Years
}

resource "random_password" "jwt" {
  length           = 40
  special          = true
  override_special = "-_"
  keepers = {
    seed = var.password_seed
  }
}

resource "jwt_hashed_token" "anon" {
  secret    = random_password.jwt.result
  algorithm = "HS256"
  claims_json = jsonencode(
    {
      role = "anon"
      iss  = "supabase"
      iat  = time_static.jwt_iat.unix
      exp  = time_static.jwt_exp.unix
    }
  )
}

resource "jwt_hashed_token" "service_role" {
  secret    = random_password.jwt.result
  algorithm = "HS256"
  claims_json = jsonencode(
    {
      role = "service_role"
      iss  = "supabase"
      iat  = time_static.jwt_iat.unix
      exp  = time_static.jwt_exp.unix
    }
  )
}

locals {
  supabase = {
    bucket_name : var.supabase_bucket_name
  }

  localstack = {
    host : "localhost.localstack.cloud"
    port : 4566
    loadbalancer_subdomain : "elb"
    storage_subdomain : "s3"
  }

  domain   = var.domain == "" ? "${local.localstack.host}:${local.localstack.port}" : var.domain
  site_url = "http://${var.loadbalancer_name}.${local.localstack.loadbalancer_subdomain}.${local.domain}"

  default_tags = [
    "supabase",
    "digitalocean",
    "terraform"
  ]

  ssh_ip_range_spaces = var.ssh_ip_range == ["0.0.0.0/0"] ? [] : var.ssh_ip_range

  inbound_rule_ssh = var.enable_ssh ? [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = var.ssh_ip_range
    }
  ] : []

  inbound_rule_db = var.enable_db_con ? [
    {
      protocol         = "tcp"
      port_range       = "5432"
      source_addresses = var.db_ip_range
    }
  ] : []

  inbound_rule = concat(
    local.inbound_rule_ssh,
    local.inbound_rule_db
  )

  tags = concat(
    local.default_tags
  )

  ttl = {
    "A"     = 1800
    "CNAME" = 43200
    "MX"    = 14400
    "TXT"   = 3600
  }

  smtp_sender_name   = var.smtp_sender_name != "" ? var.smtp_sender_name : var.smtp_admin_user
  smtp_nickname      = var.smtp_nickname != "" ? var.smtp_nickname : var.smtp_sender_name != "" ? var.smtp_sender_name : var.smtp_admin_user
  smtp_reply_to      = var.smtp_reply_to != "" ? var.smtp_reply_to : var.smtp_admin_user
  smtp_reply_to_name = var.smtp_reply_to_name != "" ? var.smtp_reply_to_name : var.smtp_sender_name != "" ? var.smtp_sender_name : var.smtp_admin_user

  docker_sock_volume_name = "docker-sock"

  supabase-dc-ecs-config = [
    {
      "name"       = "my-first-task",
      "image"      = "docker.io/playground-localstack/supabase-dc"
      "essential"  = true,
      "privileged" = true,
      "environment" = [
        { "name" = "POSTGRES_PASSWORD", "value" = random_password.psql.result },
        { "name" = "JWT_SECRET", "value" = random_password.jwt.result },
        { "name" = "ANON_KEY", "value" = jwt_hashed_token.anon.token },
        { "name" = "SERVICE_ROLE_KEY", "value" = jwt_hashed_token.service_role.token },
        { "name" = "DOMAIN", "value" = local.domain },
        { "name" = "TIMEZONE", "value" = var.timezone },
        { "name" = "POSTGRES_HOST", "value" = "db" },
        { "name" = "POSTGRES_DB", "value" = "postgres" },
        { "name" = "SPACES_REGION", "value" = var.region },
        { "name" = "SPACES_GLOBAL_S3_BUCKET", "value" = local.supabase.bucket_name },
        { "name" = "SPACES_ACCESS_KEY_ID", "value" = "test" },
        { "name" = "SPACES_SECRET_ACCESS_KEY", "value" = "test" },
        { "name" = "SPACES_ENDPOINT", "value" = "localstack:4566" },
        { "name" = "PGRST_DB_SCHEMA", "value" = "public,storage,graphql_public" },
        { "name" = "SITE_URI", "value" = "http://localhost" },
        { "name" = "ADDITIONAL_REDIRECT_URLS", value = "" },
        { "name" = "JWT_EXPIRY", "value" = tostring(3600) },
        { "name" = "DISABLE_SIGNUP", "value" = "false" },
        { "name" = "API_EXTERNAL_URL", "value" = "http://localhost" },
        { "name" = "MAILER_URLPATHS_CONFIRMATION", "value" = "/auth/v1/verify" },
        { "name" = "MAILER_URLPATHS_INVITE", "value" = "/auth/v1/verify" },
        { "name" = "MAILER_URLPATHS_RECOVER", "value" = "/auth/v1/verify" },
        { "name" = "MAILER_URLPATHS_EMAIL_CHANGE", "value" = "/auth/v1/verify" },
        { "name" = "ENABLE_EMAIL_SIGNUP", "value" = "true" },
        { "name" = "ENABLE_EMAIL_AUTOCONFIRM", "value" = "true" },
        { "name" = "SMTP_ADMIN_EMAIL", "value" = var.smtp_admin_user },
        { "name" = "SMTP_HOST", "value" = var.smtp_host },
        { "name" = "SMTP_PORT", "value" = tostring(var.smtp_port) },
        { "name" = "SMTP_USER", "value" = var.smtp_user },
        { "name" = "SMTP_PASS", "value" = "" },
        { "name" = "SMTP_SENDER_NAME", "value" = local.smtp_sender_name },
        { "name" = "ENABLE_PHONE_SIGNUP", "value" = "true" },
        { "name" = "ENABLE_PHONE_AUTOCONFIRM", "value" = "false" },
        { "name" = "STUDIO_DEFAULT_ORGANIZATION", "value" = var.studio_org },
        { "name" = "STUDIO_DEFAULT_PROJECT", "value" = var.studio_project },
        { "name" = "SUPABASE_PUBLIC_URL", "value" = "http://localhost" },
      ],
      "portMappings" = [
#        {
#          "containerPort" = 80,
#          "hostPort"      = 8080
#        },
#        {
#          "containerPort" = 443,
#          "hostPort"      = 9443
#        },
#        {
#          "containerPort" = 3000,
#          "hostPort"      = 3000
#        },
#        {
#          "containerPort" = 5432,
#          "hostPort"      = 5432
#        },
#        {
#          "containerPort" = 8000,
#          "hostPort"      = 8000
#        },
#        {
#          "containerPort" = 8443,
#          "hostPort"      = 8443
#        }
      ]
      "mountPoints" = [
        { "sourceVolume" : local.docker_sock_volume_name, "containerPath" = "/var/run/docker.sock" }
      ]
    }
  ]
}
