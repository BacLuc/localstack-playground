variable "supabase_bucket_name" {
  description = "Name of the supabase s3 bucket. Must be unique."
  type        = string
  default     = "supabase"
}

variable "region" {
  description = "The region where the Droplet will be created."
  type        = string
  default     = "us-east-1"
}

variable "domain" {
  description = "Domain name where the Supabase instance is accessible. The final domain will be of the format `supabase.example.com`"
  type        = string
  default     = ""
}

variable "timezone" {
  description = "Timezone to use for Nginx (e.g. Europe/Amsterdam)."
  type        = string
  default     = "Europe/Zurich"
}

variable "smtp_admin_user" {
  description = "`From` email address for all emails sent."
  type        = string
  default     = ""
}

variable "smtp_addr" {
  description = "Company Address of the Verified Sender. Max 100 characters. If more is needed use `smtp_addr_2`"
  type        = string
  default     = "None"
}

variable "smtp_city" {
  description = "Company city of the verified sender."
  type        = string
  default     = "Zurich"
}

variable "smtp_country" {
  description = "Company country of the verified sender."
  type        = string
  default     = "Switzerland"
}

variable "enable_ssh" {
  description = "Boolean enabling connections to droplet via SSH by opening port 22 on the firewall."
  type        = bool
  default     = true
}

variable "ssh_ip_range" {
  description = "An array of strings containing the IPv4 addresses and/or IPv4 CIDRs from which the inbound traffic will be accepted for SSH. Defaults to ALL IPv4s but it is highly suggested to choose a smaller subset."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_db_con" {
  description = "Boolean enabling connections to database by opening port 5432 on the firewall."
  type        = bool
  default     = true
}

variable "db_ip_range" {
  description = "An array of strings containing the IPv4 addresses and/or IPv4 CIDRs from which the inbound traffic will be accepted for the Database. Defaults to ALL IPv4s but it is highly suggested to choose a smaller subset."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "spaces_restrict_ip" {
  description = "Boolean signifying whether to restrict the spaces bucket to the droplet and reserved ips (as well as the ssh ips if set) or allow all ips. (N.B. If Enabled this will also disable Bucket access from DO's UI.)"
  type        = bool
  default     = false
}

variable "studio_org" {
  description = "Organization for Studio Configuration."
  type        = string
  default     = "Default Organization"
}

variable "studio_project" {
  description = "Project for Studio Configuration."
  type        = string
  default     = "Default Project"
}

variable "smtp_host" {
  description = "The external mail server hostname to send emails through."
  type        = string
  default     = "mail"
}

variable "smtp_port" {
  description = "Port number to connect to the external mail server on."
  type        = number
  default     = 1025
}

variable "smtp_user" {
  description = "The username to use for mail server requires authentication"
  type        = string
  default     = ""
}

variable "smtp_sender_name" {
  description = "Friendly name to show recipient rather than email address. Defaults to the email address specified in the `smtp_admin_user` variable."
  type        = string
  default     = ""
}

variable "smtp_addr_2" {
  description = "Company Address Line 2. Max 100 characters."
  type        = string
  default     = ""
}

variable "smtp_state" {
  description = "Company State."
  type        = string
  default     = ""
}

variable "smtp_zip_code" {
  description = "Company Zip Code."
  type        = string
  default     = ""
}

variable "smtp_nickname" {
  description = "Nickname to show recipient. Defaults to `smtp_sender_name` or the email address specified in the `smtp_admin_user` variable if neither are specified."
  type        = string
  default     = ""
}

variable "smtp_reply_to" {
  description = "Email address to show in the `reply-to` field within an email. Defaults to the email address specified in the `smtp_admin_user` variable."
  type        = string
  default     = ""
}

variable "smtp_reply_to_name" {
  description = "Friendly name to show recipient rather than email address in the `reply-to` field within an email. Defaults to `smtp_sender_name` or `smtp_reply_to` if `smtp_sender_name` is not set, or the email address specified in the `smtp_admin_user` variable if neither are specified."
  type        = string
  default     = ""
}

variable "loadbalancer_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "supabase"
}

variable "password_seed" {
  description = "The seed for the passwords. New passwords are generated if it changes"
  type = string
  default = "my secret seed"
}
